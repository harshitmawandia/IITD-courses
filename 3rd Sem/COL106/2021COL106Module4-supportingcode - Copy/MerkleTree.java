import Includes.*;
import java.util.*;
import java.lang.Math;

public class MerkleTree{
	//check TreeNode.java for more details
	public TreeNode rootnode;
	public int numdocs=0;
	

	public String InsertDocument(String document){
		CRF crf = new CRF(64);
		if(rootnode==null){			//First Insertion
			rootnode = new TreeNode();
			rootnode.val = document;
			rootnode.isLeaf=true;
			rootnode.numberLeaves=1;
			rootnode.balanceFactor=0;
			rootnode.minleafval=document;
			rootnode.maxleafval=document;
			numdocs=1;
		}else if(rootnode.numberLeaves==1){ //Second Insertion
			numdocs=2;
			TreeNode left = new TreeNode();
			TreeNode right = new TreeNode();
			if(document.compareTo(rootnode.val)<0){
				left.val=document;
				right.val= rootnode.val;
			}else{
				left.val = rootnode.val;
				right.val = document;
			}
			rootnode.val = crf.Fn(left.val+"#"+right.val);
			rootnode.isLeaf=false;
			rootnode.numberLeaves=2;
			rootnode.left = left;
			rootnode.right=right;
			rootnode.minleafval = left.val;
			rootnode.maxleafval = right.val;
			left.parent=rootnode;
			right.parent=rootnode;
			left.isLeaf=true;
			right.isLeaf=true;
			left.minleafval=left.val;
			left.maxleafval=left.val;
			right.maxleafval=right.val;
			right.minleafval=right.val;
			left.numberLeaves=1;
			right.numberLeaves=1;
			left.balanceFactor=0;
			right.balanceFactor=0;
			left.height=0;
			right.height=0;
			rootnode.height=1;
		}else{
			numdocs+=1;
			TreeNode currentNode = rootnode;
			while (!currentNode.isLeaf){
				if(currentNode.right.minleafval.compareTo(document)>0){
					currentNode=currentNode.left;
				}else{
					currentNode=currentNode.right;
				}
			}
			TreeNode node = new TreeNode();
			TreeNode leaf = new TreeNode();
			leaf.val=document;
			leaf.minleafval=document;
			leaf.maxleafval = document;
			leaf.isLeaf = true;
			node.isLeaf=false;
			node.balanceFactor=0;
			node.parent=currentNode.parent;
			if(currentNode.parent.left==currentNode){
				currentNode.parent.left=node;
			}else{
				currentNode.parent.right=node;
			}
			currentNode.parent=node;
			leaf.parent = node;
			if(document.compareTo(currentNode.val)<0){
				node.left = leaf;
				node.right= currentNode;
			}else{
				node.right=leaf;
				node.left=currentNode;
			}
			node.minleafval = node.left.val;
			node.maxleafval = node.right.val;
			leaf.balanceFactor=0;
			currentNode.balanceFactor=0;
			node.numberLeaves=2;
			leaf.numberLeaves=1;
			currentNode.numberLeaves=1;
			node.val = crf.Fn(node.left.val+"#"+node.right.val);
			leaf.updateHeight();
			currentNode = node;
			while (currentNode.parent!=null){
				currentNode.parent.val = crf.Fn(currentNode.parent.left.val+"#"+currentNode.parent.right.val);
				currentNode.parent.minleafval = currentNode.parent.left.minleafval;
				currentNode.parent.maxleafval = currentNode.parent.right.maxleafval;
				if(currentNode==currentNode.parent.left){
					currentNode.parent.balanceFactor+=1;
				}else{
					currentNode.parent.balanceFactor-=1;
				}
				currentNode.parent.numberLeaves+=1;
				currentNode=currentNode.parent;
			}

			if(node.parent.parent!=null && node.parent.parent.balanceFactor == 2){
				if(node.parent.balanceFactor==1){
					node.parent.parent.SingleRightRotation();
				}else{
					node.parent.parent.DoubleLeftRightRotation();
				}
			}else if(node.parent.parent!=null && node.parent.parent.balanceFactor == -2){
				if(node.parent.balanceFactor==1){
					node.parent.parent.DoubleRightLeftRotation();
				}else{
					node.parent.parent.SingleLeftRotation();
				}
			}

		}
		return rootnode.val;
	}
	
	public String DeleteDocument(String document){

		return "";
	}
}


