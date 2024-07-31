import Includes.*;

public class AuthList{
	public static final String start_string = "2019AIM1003";
	public Node firstNode;
	public Node lastNode;

	/*
		Note that the Exceptions have already been defined for you in the includes file,
		you just have to raise them accordingly

	*/

	/*
	Notice that this function is static, the reason why this is static is that we don't want this to be tied with
	an object of the class AuthList.
	*/
	public static boolean CheckList(AuthList current, String proof) throws AuthenticationFailedException {
		CRF obj = new CRF(64);
		Node curr = current.firstNode;
		boolean initial = true;
		while(curr != null){
			if(initial){
				String hsh = obj.Fn(AuthList.start_string + "#" + curr.data.value);
				if(!curr.dgst.equals(hsh)) {
					throw new AuthenticationFailedException();
				}
				initial = false;
				curr = curr.next;
			}else if(curr == current.lastNode){
				String hsh = obj.Fn(curr.previous.dgst + "#" + curr.data.value);
				if(!curr.dgst.equals(hsh) || !curr.dgst.equals(proof)) {
					System.out.println(hsh);
					System.out.println(curr.dgst);
					System.out.println(proof);
					throw new AuthenticationFailedException();
				}
				curr = curr.next;
			}else{
				String hsh = obj.Fn(curr.previous.dgst + "#" + curr.data.value);
				if(!curr.dgst.equals(hsh))  {
					throw new AuthenticationFailedException();
				}
				curr = curr.next;
			}
		}
		return true;
	}


	public String InsertNode(Data datainsert, String proof) throws AuthenticationFailedException {

		if(!CheckList(this,proof))
		throw new AuthenticationFailedException();

		CRF obj = new CRF(64);
		Node node = new Node();
		node.data = datainsert;
		node.previous = null;
		node.next = null;

		if(this.firstNode == null)
		{		node.dgst = obj.Fn(this.start_string + "#" + node.data.value);
				this.firstNode = node;
		}
		else
		{
			node.dgst=obj.Fn(this.lastNode.dgst + "#" + node.data.value);
			node.previous = this.lastNode;
			this.lastNode.next = node;
		}
		this.lastNode = node;
		return node.dgst;
	}



	/*==========================
    |- To be done by students -|
    ==========================*/


    /* Lab test to-do */
	public String Delete2ndLast() throws AuthenticationFailedException,NodeDoesNotExistException {
		CRF crf = new CRF(64);
		
		if(lastNode==null){
			System.out.println(lastNode);
			throw new NodeDoesNotExistException();
		}else if(lastNode==firstNode){
			throw new NodeDoesNotExistException();
		}else{
			if(lastNode.previous.previous!=null){
				Data dataStore = new Data();
				dataStore.value = lastNode.data.value;
				lastNode.previous.previous.next=null;
				Node node1= lastNode.previous.previous;
				lastNode = lastNode.previous.previous;
				InsertNode(dataStore,node1.dgst);
				//lastNode.dgst = crf.Fn(node1.dgst + lastNode.data.value);
				return lastNode.dgst;
			}else{
				lastNode.previous=null;
				lastNode.dgst = crf.Fn(start_string + "#" + lastNode.data.value);
				firstNode=lastNode;
				return lastNode.dgst;
			}
			
		}
	}

}
