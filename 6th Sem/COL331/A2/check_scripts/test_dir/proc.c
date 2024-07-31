#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
  p->sched_policy = -1;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;
  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
  // cprintf("exiting: %d\n", curproc->pid);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }



  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.

void
scheduler(void)
{
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    int found = -1;
    struct proc *p, *q, *x, *r;
    acquire(&ptable.lock);

    

    // EDF Scheduling
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      if(found == -1 && p->sched_policy == 0){
        found = p->pid;
        x = p;
      }else if(p->sched_policy == 0 && p->deadline + p->arrival_time < x->deadline + x->arrival_time){
        found = p->pid;
        x = p;
      }else if(p->sched_policy == 0 && p->pid < found){
        found = p->pid;
        x = p;
      }
    }

    if(found!=-1){
      found=-1;
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = x;
      switchuvm(x);
      x->state = RUNNING;
      x->elapsed_time++;

      swtch(&(c->scheduler), x->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
      release(&ptable.lock);
      continue;
    }


    //RMS Scheduling

    int weight_found = 4;

    for(p = ptable.proc;p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      if(found == -1 && p->sched_policy == 1){
        found = p->pid;
        r = p;
        weight_found = ((30-p->rate)*3 + 28)/29 > 1 ? ((30-p->rate)*3 + 28)/29 : 1;
      } else {
        int weight = ((30-p->rate)*3 + 28)/29 > 1 ? ((30-p->rate)*3 + 28)/29 : 1;
        if(p->sched_policy == 1 && weight < weight_found){
          found = p->pid;
          weight_found = weight;
          r = p;
        }else if(p->sched_policy == 1 && weight == weight_found && p->pid < found){
          found = p->pid;
          weight_found = weight;
          r = p;
        }
      }
    }
  

    if(found!=-1){
      // cprintf("Found =%d\n",found);
      found=-1;
      weight_found = 4;
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = r;
      switchuvm(r);
      r->state = RUNNING;
      r->elapsed_time++;

      swtch(&(c->scheduler), r->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
      release(&ptable.lock);
      continue;
    }

    for(q = ptable.proc;q < &ptable.proc[NPROC]; q++){
      if(q->state != RUNNABLE)
        continue;

      
      // cprintf("HEHEHEHHE %d\n", q->pid);
      

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = q;
      switchuvm(q);
      q->state = RUNNING;
      if(q->sched_policy <0)
        q->elapsed_time++;

      swtch(&(c->scheduler), q->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

int sys_sched_policy(int pid, int policy){
  argint(0,&pid);
  argint(1,&policy);
  // cprintf("sched_policy: %d", myproc()->sched_policy);

  // struct proc *p;
  // acquire(&ptable.lock);
  // for(p=ptable.proc; p<&ptable.proc[NPROC]; p++){
  //   if(p->pid == pid){
  //     p->sched_policy = policy;
  //     p->arrival_time = ticks;
  //     p->elapsed_time = 0;
  //     release(&ptable.lock);
  //     return 0;
  //   }
  // }
  // release(&ptable.lock);
  // return -1;
  
  
  struct proc *p, *q;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->sched_policy = policy;
      p->arrival_time = ticks;
      p->elapsed_time = 0;
      int utility = 0;
      int schedulable = 0;
      float u = 0;
      p->schedulable = -1;
      //check if now all processes are schedulable
      if(p->sched_policy == 0){
        //check edf schedulability
        schedulable = 0;
        for(q = ptable.proc; q < &ptable.proc[NPROC]; q++){
          if((q->state == RUNNABLE|| q->state==RUNNING) && q->sched_policy==0 && q->schedulable!=0){
            // cprintf("pid= %d, exec=%d, deadline=%d, state=%d, schedulable=%d\n", q->pid, q->exec_time, q->deadline, q->state, q->schedulable);
            u += ((float)q->exec_time)/((float)q->deadline);
          }
        }
        // cprintf("utility = %d\n",u);
        if(u < 1){
          schedulable = 1;
          p->schedulable = 1;
        }
      }else if(p->sched_policy == 1){
        //check rms schedulability
        schedulable = 0;
        int n = 0;
        for(q = ptable.proc; q < &ptable.proc[NPROC]; q++){
          if((q->state == RUNNABLE || q->state == RUNNING) && q->sched_policy==1 && q->schedulable!=0){
            // cprintf("pid= %d, exec=%d, rate=%d, state=%d, schedulable=%d\n", q->pid, q->exec_time, q->rate, q->state, q->schedulable);
            utility += q->exec_time*q->rate;
            n++;
          }
        }
        // cprintf("utility = %d\n",utility);
        float maxPossibleUtilisation[]= { -1,1, 0.828427, 0.779763, 0.756828, 0.743492, 0.734772, 0.728627, 0.724062, 0.720538, 0.717735, 0.715452, 0.713557, 0.711959, 0.710593, 0.709412, 0.708381, 0.707472, 0.706666, 0.705946, 0.705298, 0.704713, 0.704182, 0.703698, 0.703254, 0.702846, 0.702469, 0.702121, 0.701798, 0.701497, 0.701217, 0.700954, 0.700709, 0.700478, 0.700261, 0.700056, 0.699863, 0.699681, 0.699508, 0.699344, 0.699188, 0.69904, 0.698898, 0.698764, 0.698636, 0.698513, 0.698396, 0.698284, 0.698176, 0.698073, 0.697974, 0.697879, 0.697788, 0.6977, 0.697615, 0.697533, 0.697455, 0.697379, 0.697306, 0.697235, 0.697166, 0.6971, 0.697036, 0.696974, 0.696914, 0.696856, 0.6968, 0.696745, 0.696692, 0.69664, 0.69659, 0.696542, 0.696494, 0.696448, 0.696404, 0.69636, 0.696318, 0.696276, 0.696236, 0.696197, 0.696159, 0.696121, 0.696085, 0.69605, 0.696015, 0.695981, 0.695948, 0.695916, 0.695884, 0.695853, 0.695823, 0.695794, 0.695765, 0.695737, 0.695709, 0.695682, 0.695656, 0.69563, 0.695604, 0.695579};

        if(utility/100.0 < maxPossibleUtilisation[n]){
          schedulable = 1;
          p->schedulable = 1;
        }

      }
      if(schedulable!=0){
        release(&ptable.lock);
        return 0;
      }
      else{
        // cprintf("process %d is not schedulable\n", p->pid);
        p->schedulable = 0;
        p->killed = 1;
        // Wake process from sleep if necessary.
        if(p->state == SLEEPING)
          p->state = RUNNABLE;
        release(&ptable.lock);
        return -22;
      }
    }
  }
  release(&ptable.lock);
  return -22;
}

int sys_exec_time(int pid, int exec_time){
  argint(0,&pid);
  argint(1,&exec_time);

  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->exec_time = exec_time;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -22;
}

int sys_deadline(int pid, int deadline){
  argint(0,&pid);
  argint(1,&deadline);

  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->deadline = deadline;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -22;
}


int sys_rate(int pid, int rate){
  argint(0,&pid);
  argint(1,&rate);

  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->rate = rate;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -22;
}

