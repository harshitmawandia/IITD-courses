public class Pair<A, B>{
	public A First;
	public B Second;
	public Pair(A _first, B _second) {
        this.First = _first;
        this.Second = _second;
    }
    public Pair(){
    	
    }
    public A get_first() {
        return First;
    }
    public B get_second() {
        return Second;
    }
}