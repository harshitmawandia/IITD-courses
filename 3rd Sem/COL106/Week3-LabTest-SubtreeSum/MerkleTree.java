import Includes.*;
import java.util.*;

public class MerkleTree{
	
	// Check the TreeNode.java file for more details
	public TreeNode rootnode;

	/*==========================
    |- To be done by students -|
    ==========================*/
    /* Lab test to-do */
	public int SubtreeSum(){
		
		TreeNode CN = rootnode;
		int sum = 0;
		if(CN==null){
			return 0;
		}else if(CN.left==null && CN.right==null && CN.middle==null){
			System.out.println(CN.val);
			CN.subtree_sum = CN.val;
			return CN.val;
		}else{
				int a=0,b=0,c=0;
				if(CN.left!=null){
						CN.left.subtree_sum = SubtreeSum(CN.left);
						a=SubtreeSum(CN.left);
				}
				if(CN.right!=null){
						CN.right.subtree_sum = SubtreeSum(CN.right);
						b=SubtreeSum(CN.right);
				}
				if(CN.middle!=null){
						CN.middle.subtree_sum = SubtreeSum(CN.middle);
						c=SubtreeSum(CN.middle);
				}
			CN.subtree_sum = a+b+c + CN.val;
			return  CN.subtree_sum;
		}

		
		
	}

	public int SubtreeSum(TreeNode node){
		TreeNode CN = node;
		int sum = 0;
		if(CN==null){
			return 0;
		}else if(CN.left==null && CN.right==null && CN.middle==null){
				CN.subtree_sum = CN.val;
			return CN.val;

		}else{
				int a=0,b=0,c=0;
				if(CN.left!=null){
						CN.left.subtree_sum = SubtreeSum(CN.left);
						a=SubtreeSum(CN.left);
				}
				if(CN.right!=null){
						CN.right.subtree_sum = SubtreeSum(CN.right);
						b=SubtreeSum(CN.right);
				}
				if(CN.middle!=null){
						CN.middle.subtree_sum = SubtreeSum(CN.middle);
						c=SubtreeSum(CN.middle);
				}
			CN.subtree_sum =a+b+c + CN.val;
			return CN.subtree_sum;
		}	
	}
}