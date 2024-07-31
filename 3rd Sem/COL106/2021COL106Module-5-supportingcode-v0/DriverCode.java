import Includes.*;
import java.util.*;
import java.io.*;

public class DriverCode{
	public static void main(String[] args) {
		List<Pair<String,Integer>> documents = new ArrayList<Pair<String,Integer>> ();
		documents.add(new Pair <String,Integer> ("Himanshu",98));
		documents.add(new Pair <String,Integer> ("Aditya",41));
		documents.add(new Pair <String,Integer> ("Rishabh",63));
		documents.add(new Pair <String,Integer> ("Garima",11));
		documents.add(new Pair <String,Integer> ("Ramesh",91));
		documents.add(new Pair <String,Integer> ("Vaibhav",0));
		documents.add(new Pair <String,Integer> ("Ritika",63));
		documents.add(new Pair <String,Integer> ("Saiyam",100));

		System.out.println("Building Merkle Tree...");
		MerkleTree tree = new MerkleTree();
		try
		{
			tree.Build(documents);
			boolean correct = (tree.rootnode!=null);
			correct &= (tree.numstudents==8);
			correct &= (tree.rootnode.maxleafval == 100);
			correct &= (tree.rootnode.left.maxleafval == 98);
			correct &= (tree.rootnode.left.left.maxleafval == 98);
			correct &= (tree.rootnode.left.right.maxleafval == 63);
			correct &= (tree.rootnode.right.maxleafval == 100);
			correct &= (tree.rootnode.right.left.maxleafval == 91);
			correct &= (tree.rootnode.right.right.maxleafval == 100);

			CRF crf = new CRF(64);
			String corr_dgst = crf.Fn(crf.Fn(crf.Fn("Himanshu_98#Aditya_41")+"#"+crf.Fn("Rishabh_63#Garima_11"))+"#"+crf.Fn(crf.Fn("Ramesh_91#Vaibhav_0")+"#"+crf.Fn("Ritika_63#Saiyam_100")));
			String obt_dgst = tree.rootnode.val;
			correct &= (corr_dgst.equals(obt_dgst));

			if (!correct) System.out.println("ERROR: Tree not built correctly");
			else System.out.println("Tree built correctly!");
		}
		catch (Exception e)
		{
			System.out.println("ERROR: An exception was thrown");
		}


		System.out.println("Updating a document...");
		try
		{
			String v = tree.UpdateDocument(2,99);
			boolean correct = (tree.rootnode!=null);
			correct &= (tree.numstudents==8);
			correct &= (tree.rootnode.maxleafval == 100);
			correct &= (tree.rootnode.left.maxleafval == 99);
			correct &= (tree.rootnode.left.left.maxleafval == 98);
			correct &= (tree.rootnode.left.right.maxleafval == 99);


			CRF crf = new CRF(64);
			String corr_dgst = crf.Fn(crf.Fn(crf.Fn("Himanshu_98#Aditya_41")+"#"+crf.Fn("Rishabh_99#Garima_11"))+"#"+crf.Fn(crf.Fn("Ramesh_91#Vaibhav_0")+"#"+crf.Fn("Ritika_63#Saiyam_100")));
			String obt_dgst = tree.rootnode.val;
			correct &= (corr_dgst.equals(obt_dgst));
			corr_dgst = corr_dgst+"_"+Integer.toString(tree.rootnode.maxleafval);
			correct &= (v.equals(corr_dgst));

			if (!correct) System.out.println("ERROR: Not updated correctly");
			else System.out.println("Updated correctly!");
		}
		catch (Exception e)
		{
			System.out.println("ERROR: An exception was thrown");
		}


		BlockChain al = new BlockChain();
		System.out.println("Checking BlockChain...");
		try
		{
			String proof = "LabModule5";
			String new_proof = al.InsertBlock(documents, 2021);
			boolean correct = (al.lastBlock!=null);
			correct &= (al.firstBlock!=null);
			correct &= (al.lastBlock.previous==null);
			correct &= (al.firstBlock.previous==null);
			correct &= (al.firstBlock.next==null);
			correct &= (al.lastBlock.next==null);
			correct &= (al.firstBlock.year==2021);

			CRF crf = new CRF(64);
			String corr_dgst = crf.Fn(crf.Fn(crf.Fn("Himanshu_98#Aditya_41")+"#"+crf.Fn("Rishabh_99#Garima_11"))+"#"+crf.Fn(crf.Fn("Ramesh_91#Vaibhav_0")+"#"+crf.Fn("Ritika_63#Saiyam_100")));
			corr_dgst += "_100";
			String obt_dgst = al.lastBlock.value;
			correct &= corr_dgst.equals(obt_dgst);
			corr_dgst = crf.Fn(proof+"#"+corr_dgst);
			correct &= corr_dgst.equals(new_proof);
			// proof = new_proof;
			// new_proof = al.UpdateScore(2, 99, 2021, new_proof);
			// corr_dgst = crf.Fn(crf.Fn(crf.Fn(crf.Fn("Himanshu_98#Aditya_41")+"#"+crf.Fn("Rishabh_99#Garima_11"))+"#"+crf.Fn(crf.Fn("Ramesh_91#Vaibhav_0")+"#"+crf.Fn("Ritika_63#Saiyam_100")))+"#"+"_100");
			// correct &= corr_dgst.equals(new_proof);

			if (!correct) System.out.println("ERROR: in BlockChain");
			else System.out.println("BlockChain works fine!");
		}
		catch (Exception e)
		{
			System.out.println("ERROR: An exception was thrown");
		}

		System.out.println("\nTests Completed");
	}
}
