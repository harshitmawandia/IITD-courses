import Includes.*;

/* Autograder */
public class DriverCode{

	public static int find_len(AuthList current){
		Node curr = current.firstNode;
		int size=0;
		while(curr!=null)
		{
			// System.out.println(curr.data.value);
			curr=curr.next;
			size++;
		}
		return size;
	}

	public static void main(String[] args) {
    CRF obj = new CRF(64);
		AuthList blockchain = new AuthList();
		String message = "How I need a drink, alcoholic in nature, after the heavy lectures involving quantum mechanics!";
		String[] arr=message.split(" ");
		int num_del=14;
		// assert arr.length>num_del;
		String proof1 = null;
		int flag=0;
		// Inserting new documents in the blockchain
		try{
			for(int i=0;i<arr.length;i++)
			{
				Data document = new Data();
				document.value = arr[i];
				proof1 = blockchain.InsertNode(document, proof1);
			}
		}catch(Exception e){
			System.out.println(e+ "\n");
		}
		for(int i=0;i<num_del;i++){
			try{
				proof1=blockchain.Delete2ndLast();
				if (!AuthList.CheckList(blockchain, proof1)){
					throw new AuthenticationFailedException();
				}
				System.out.print("Test Case "+Integer.toString(i)+":\t");
				System.out.println("Deletion operation successful");
				
			}catch(Exception e){
				System.out.println(e+ "\n");
				System.out.print("Test Case "+Integer.toString(i)+":\t");
				System.out.println("Deletion operation failed");
			}
		}
		
		try{
			String proof3=blockchain.Delete2ndLast();
			throw new Exception("No exception thrown");
		}catch(NodeDoesNotExistException e){
			System.out.print("Test Case 14:\t");
			System.out.println("Deletion operation successful");
		}catch(Exception e){
			System.out.print("Test Case 14:\t");
			System.out.println("Deletion operation failed");
			System.out.println(e.getMessage());
		}

		AuthList blockchain2 = new AuthList();
		String proof2=null;
		try{
		for(int i=0;i<arr.length-num_del-1;i++)
		{
			Data document = new Data();
			document.value = arr[i];
			proof2 = blockchain2.InsertNode(document, proof2);
		}
		Data document = new Data();
		document.value = arr[arr.length-1];
		proof2 = blockchain2.InsertNode(document, proof2);
		}
		catch(Exception e)
		{
			System.out.println(e+ "\n");
		}
		try{
			System.out.println(proof1.equals(proof2)?"AuthList Correct!!":"AuthList Failed!!");
		}catch (Exception e){
			System.out.println("AuthList Failed!!");
		}


		
	}
}
