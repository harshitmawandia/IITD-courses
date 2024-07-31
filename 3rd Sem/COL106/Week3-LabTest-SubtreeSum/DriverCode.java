import Includes.*;
import java.util.*;
import java.io.*;

public class DriverCode{
	public static void main(String[] args)
    {
		boolean tc1 = true, tc2 = true, tc3 = true, tc4 = true;

		int ret_val;
        MerkleTree tree1 = new MerkleTree(); //Arbitary tree
        tree1.rootnode = new TreeNode(null,26);
        tree1.rootnode.left = new TreeNode(tree1.rootnode,20);
        tree1.rootnode.middle = new TreeNode(tree1.rootnode,3);
        tree1.rootnode.right = new TreeNode(tree1.rootnode,7);
        tree1.rootnode.left.left = new TreeNode(tree1.rootnode.left,16);
        tree1.rootnode.left.right = new TreeNode(tree1.rootnode.left,2);
        ret_val = tree1.SubtreeSum();
        if(!(
			ret_val==74 && 
			tree1.rootnode.left.left.subtree_sum==16 && 
			tree1.rootnode.left.right.subtree_sum==2 && 
			tree1.rootnode.left.subtree_sum==38 && 
			tree1.rootnode.middle.subtree_sum==3 && 
			tree1.rootnode.right.subtree_sum==7 && 
			tree1.rootnode.subtree_sum==74
		)){
			tc1 = false;
		}
		System.out.println(tree1.rootnode.subtree_sum);
        System.out.println(tc1?"Test case 1 of 4: passed":"Test case 1 of 4: failed");
        
        MerkleTree tree2 = new MerkleTree();  //Fully balanced tree
        tree2.rootnode = new TreeNode(null,1);
        tree2.rootnode.left = new TreeNode(tree2.rootnode,2);
        tree2.rootnode.middle = new TreeNode(tree2.rootnode,3);
        tree2.rootnode.right = new TreeNode(tree2.rootnode,4);
        tree2.rootnode.left.left = new TreeNode(tree2.rootnode.left,5);
        tree2.rootnode.left.middle = new TreeNode(tree2.rootnode.left,6);
        tree2.rootnode.left.right = new TreeNode(tree2.rootnode.left,7);
        tree2.rootnode.middle.left = new TreeNode(tree2.rootnode.middle,8);
        tree2.rootnode.middle.middle = new TreeNode(tree2.rootnode.middle,9);
        tree2.rootnode.middle.right = new TreeNode(tree2.rootnode.middle,10);
        tree2.rootnode.right.left = new TreeNode(tree2.rootnode.right,11);
        tree2.rootnode.right.middle = new TreeNode(tree2.rootnode.right,12);
        tree2.rootnode.right.right = new TreeNode(tree2.rootnode.right,13);
        ret_val = tree2.SubtreeSum();
        if(!(
			ret_val==91 && 
			tree2.rootnode.left.left.subtree_sum==5 && 
			tree2.rootnode.left.middle.subtree_sum==6 && 
			tree2.rootnode.left.right.subtree_sum==7 && 
			tree2.rootnode.middle.left.subtree_sum==8 && 
			tree2.rootnode.middle.middle.subtree_sum==9 && 
			tree2.rootnode.middle.right.subtree_sum==10 && 
			tree2.rootnode.right.left.subtree_sum==11 && 
			tree2.rootnode.right.middle.subtree_sum==12 && 
			tree2.rootnode.right.right.subtree_sum==13 && 
			tree2.rootnode.left.subtree_sum==20 && 
			tree2.rootnode.middle.subtree_sum==30 && 
			tree2.rootnode.right.subtree_sum==40 && 
			tree2.rootnode.subtree_sum==91
		)){
			tc2 = false;
		}
        System.out.println(tc2?"Test case 2 of 4: passed":"Test case 2 of 4: failed");
        
        MerkleTree tree3 = new MerkleTree();  //Empty tree
        ret_val = tree3.SubtreeSum();
		if(!(
			ret_val==0
		)){
			tc3 = false;
		}
        System.out.println(tc3?"Test case 3 of 4: passed":"Test case 3 of 4: failed");
        
        MerkleTree tree4 = new MerkleTree(); //Middle skewed tree
        tree4.rootnode = new TreeNode(null,6);
        tree4.rootnode.middle = new TreeNode(tree4.rootnode,2);
        tree4.rootnode.middle.middle = new TreeNode(tree4.rootnode.middle,10);
        tree4.rootnode.middle.middle.middle = new TreeNode(tree4.rootnode.middle.middle,8);
        ret_val = tree4.SubtreeSum();
        if(!(
			ret_val==26 && 
			tree4.rootnode.middle.middle.middle.subtree_sum==8 && 
			tree4.rootnode.middle.middle.subtree_sum==18 && 
			tree4.rootnode.middle.subtree_sum==20 && 
			tree4.rootnode.subtree_sum==26
		)){
			tc4 = false;
		}
        System.out.println(tc4?"Test case 4 of 4: passed":"Test case 4 of 4: failed");
    }
	
}