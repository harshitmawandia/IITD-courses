import Includes.*;

import java.sql.SQLOutput;

public class TreeNode{
	public TreeNode parent;
	public TreeNode left;
	public TreeNode right;
	public String val;
	public boolean isLeaf;
	public int numberLeaves;
	public String maxleafval;
	public String minleafval;
	public int balanceFactor;
	public int height=0;


	public int find_height()
	{
		if(this.left==null && this.right == null)
		{
			this.height = 0;
			return 0;
		}
		else
		{
			if(this.left != null && this.right != null) {
				this.height = 1 + Math.max(this.left.find_height(), this.right.find_height());
				return this.height;
			}
			else if(this.left == null)
			{
				this.height = 1 + this.right.find_height();
				return this.height;
			}
			else
			{
				this.height = 1 + this.left.find_height();
				return this.height ;
			}
		}
	}
	public void updateHeight(){
		TreeNode currentNode = this;
		while (currentNode.parent!=null){
			currentNode.parent.height = 1 + Math.max(currentNode.parent.left.height,currentNode.parent.right.height);
			currentNode=currentNode.parent;
		}
	}

	public TreeNode SingleLeftRotation(){
		CRF crf = new CRF(64);
		TreeNode right_left = this.right.left;
		this.right.right.parent = this;
		this.right = this.right.right;
		TreeNode left = new TreeNode();
		this.left.parent=left;
		left.left=this.left;
		left.right=right_left;
		left.parent=this;
		right_left.parent=left;
		left.val = crf.Fn(left.left.val+"#"+left.right.val);
		this.left=left;
		this.val= crf.Fn(this.left.val+"#"+this.right.val);
		left.balanceFactor=left.left.height-left.right.height;
		this.balanceFactor=this.left.height-this.right.height;
		left.isLeaf=false;
		left.numberLeaves=left.left.numberLeaves+left.right.numberLeaves;
		this.numberLeaves=this.left.numberLeaves+this.right.numberLeaves;
		left.maxleafval=left.right.maxleafval;
		left.minleafval=left.left.minleafval;
		this.maxleafval=this.right.maxleafval;
		this.minleafval=this.left.minleafval;
		TreeNode currentNode = this;
		this.val = crf.Fn(this.left.val+"#"+this.right.val);
		while(currentNode.parent!=null){
			currentNode.parent.val = crf.Fn(currentNode.parent.left.val+"#"+currentNode.parent.right.val);
			currentNode=currentNode.parent;
//			currentNode.parent.minleafval = currentNode.parent.right.minleafval;
//			currentNode.parent.maxleafval = currentNode.parent.left.maxleafval;
		}
		return this;
	}
	
	public TreeNode SingleRightRotation(){
		CRF crf = new CRF(64);
		TreeNode left_right = this.left.right;
		this.left.left.parent=this;
		this.left = this.left.left;
		TreeNode right = new TreeNode();
		this.right.parent=right;
		right.right=this.right;
		right.left = left_right;
		right.parent = this;
		left_right.parent=right;
		right.val = crf.Fn(right.left.val+"#"+right.right.val);
		this.right=right;
		this.val = crf.Fn(this.left.val+"#"+this.right.val);
		right.balanceFactor = 0;
		this.balanceFactor=0;
		right.isLeaf=false;
		right.numberLeaves=right.left.numberLeaves+ right.right.numberLeaves;
		this.numberLeaves=this.left.numberLeaves+this.right.numberLeaves;
		right.maxleafval=right.right.maxleafval;
		right.minleafval=right.left.minleafval;
		this.maxleafval=right.maxleafval;
		this.minleafval=this.left.minleafval;
		TreeNode currentNode = this;
		this.val = crf.Fn(this.left.val+"#"+this.right.val);
		while(currentNode.parent!=null){
			currentNode.parent.val = crf.Fn(currentNode.parent.left.val+"#"+currentNode.parent.right.val);
			currentNode=currentNode.parent;
		}
		return this;
	}
	
	public TreeNode DoubleLeftRightRotation(){
		CRF crf = new CRF(64);
		TreeNode left_right_right = this.left.right.right;
		TreeNode right_right = this.right;
		this.left.right = this.left.right.left;
		this.left.right.parent = this.left;
		this.left.val = crf.Fn(this.left.left.val+"#"+this.left.right.val);
		TreeNode right = new TreeNode();
		right.isLeaf=false;
		right.parent=this;
		this.right = right;
		right.right=right_right;
		right.left = left_right_right;
		right_right.parent=right;
		left_right_right.parent=right;
		right.val = crf.Fn(right.left.val+"#"+right.left.val);
		right.numberLeaves=right.left.numberLeaves+right.right.numberLeaves;
		this.left.numberLeaves=this.left.left.numberLeaves+this.left.right.numberLeaves;
		this.numberLeaves=this.left.numberLeaves+this.right.numberLeaves;
		this.left.maxleafval=this.left.right.maxleafval;
		this.right.minleafval=this.right.left.minleafval;
		this.right.maxleafval=this.right.right.maxleafval;
		this.right.balanceFactor=0;
		this.balanceFactor=0;
		this.left.balanceFactor=0;
		this.maxleafval=this.right.maxleafval;
		this.minleafval=this.left.minleafval;
		TreeNode currentNode = this;
		this.val = crf.Fn(this.left.val+"#"+this.right.val);
		while(currentNode.parent!=null){
			currentNode.parent.val = crf.Fn(currentNode.parent.left.val+"#"+currentNode.parent.right.val);
			currentNode=currentNode.parent;
		}
		return this;
	}
	
	public TreeNode DoubleRightLeftRotation(){
		CRF crf = new CRF(64);
		TreeNode right_left_left = this.right.left.left;
		TreeNode left_left = this.left;
		this.right.left = this.right.left.right;
		this.right.left.parent=this.right;
		this.right.val = crf.Fn(this.right.left.val+"#"+this.right.right.val);
		TreeNode left =new TreeNode();
		left.isLeaf=false;
		left.parent=this;
		this.left=left;
		left.left=left_left;
		left.right=right_left_left;
		left_left.parent=left;
		right_left_left.parent=left;
		left.val = crf.Fn(left.left.val+"#"+left.right.val);
		left.numberLeaves=left.left.numberLeaves+left.right.numberLeaves;
		this.right.numberLeaves=this.right.left.numberLeaves+this.right.right.numberLeaves;
		this.numberLeaves = this.left.numberLeaves+this.right.numberLeaves;
		this.left.minleafval = left.left.minleafval;
		this.left.maxleafval = left.right.maxleafval;
		this.right.minleafval = this.right.left.minleafval;
		this.left.balanceFactor=0;
		this.balanceFactor=0;
		this.right.balanceFactor=0;
		this.maxleafval=this.right.maxleafval;
		this.minleafval=this.left.minleafval;
		this.val = crf.Fn(this.left.val+"#"+this.right.val);
		TreeNode currentNode = this;
		while(currentNode.parent!=null){
			currentNode.parent.val = crf.Fn(currentNode.parent.left.val+"#"+currentNode.parent.right.val);
			currentNode=currentNode.parent;
		}
		return this;
	}
}

