import Includes.*;
import java.util.*;

public class MerkleTree{

	// Check the TreeNode.java file for more details
	public TreeNode rootnode;
	public int numstudents;

	public String Build(List<Pair<String,Integer>> documents){
		ArrayList<TreeNode> arrayList = new ArrayList<>();
		ArrayList<TreeNode> arrayList2 = new ArrayList<>();
		numstudents = documents.size();
		for(int j = 0; j < Math.log(numstudents)/Math.log(2)+1; j++){
			for(int i = 0; i < (documents.size())/(Math.pow(2,j)); i++){
				CRF crf = new CRF(64);
				TreeNode treeNode = new TreeNode();

				if(j==0){
					treeNode.val= documents.get(i).First+"_"+documents.get(i).Second;
					arrayList2.add(treeNode);
					treeNode.maxleafval = documents.get(i).Second;
					treeNode.numberLeaves = 1;
					treeNode.isLeaf= true;
				}else{
					treeNode.val = crf.Fn(arrayList.get(i*2).val+"#"+ arrayList.get(i*2 +1).val);
					arrayList.get(i*2).parent = treeNode;
					arrayList.get(i*2+1).parent = treeNode;
					treeNode.left=arrayList.get(i*2);
					treeNode.right=arrayList.get(i*2+1);
					treeNode.maxleafval = Math.max(treeNode.left.maxleafval,treeNode.right.maxleafval);
					treeNode.numberLeaves = treeNode.left.numberLeaves + treeNode.right.numberLeaves;
					treeNode.isLeaf = false;
					arrayList2.add(treeNode);
				}
			}
			arrayList=arrayList2;
			arrayList2= new ArrayList<TreeNode>();
		}
		rootnode = arrayList.get(0);
		return rootnode.val;
	}

	/*
		Pair is a generic data structure defined in the Pair.java file
		It has two attributes - First and Second, that can be set either manually or
		using the constructor

		Edit: The constructor is added
	*/


	public String UpdateDocument(int student_id, int newScore){
		ArrayList<Integer> path = new ArrayList<>();
		int a = student_id;
		for(int i = 0; i < Math.log(numstudents)/Math.log(2)+1;i++){
			path.add(a);
			a=(a)/2;
		}
		ArrayList<Pair<TreeNode,TreeNode>> SCpath = new ArrayList<Pair<TreeNode, TreeNode>>();
		TreeNode currentNode = rootnode;
		for(int i= path.size()-1; i >=0; i--){
			Pair<TreeNode,TreeNode> pair;
			if(path.get(i)%2==0){
				TreeNode s1 = currentNode;
				TreeNode s2;
				if(currentNode.parent!=null){
					s2 = currentNode.parent.right;
				}else{
					s2 = null;
				}
				pair = new Pair<>(s1,s2);
			}else{
				TreeNode s2 = currentNode;
				TreeNode s1;
				if(currentNode.parent!=null){
					s1 = currentNode.parent.left;
				}else{
					s1 = null;
				}
				pair = new Pair<>(s1,s2);
			}
			SCpath.add(pair);
			if(i>0){
				if(path.get(i-1)%2==0){
					currentNode=currentNode.left;
				}else{
					currentNode=currentNode.right;
				}
			}else {
				currentNode.val=currentNode.val.substring(0,currentNode.val.indexOf('_')+1)+newScore;
//				System.out.println(currentNode.val);
				currentNode.maxleafval = newScore;
				CRF crf = new CRF(64);
				for(int j = SCpath.size()-1;j>=0;j--){
					if(j!=0){
						SCpath.get(j).First.parent.val = crf.Fn(SCpath.get(j).First.val + "#" +SCpath.get(j).Second.val);
						SCpath.get(j).First.parent.maxleafval = Math.max(SCpath.get(j).First.maxleafval,SCpath.get(j).Second.maxleafval);
					}else{
						return SCpath.get(j).First.val;
					}
				}
			}


		}

		return "";
	}
}
