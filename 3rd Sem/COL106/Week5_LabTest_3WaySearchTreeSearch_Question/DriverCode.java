import Includes.*;
import java.util.*;
import java.io.*;

public class DriverCode{

	public static void main(String[] args)
    {

		MerkleTree t0 = new MerkleTree();      // Empty Tree

		MerkleTree t1 = new MerkleTree();      // Merkle Tree with just 1 node
		TreeNode r1 = new TreeNode(1, 2);
		t1.rootnode = r1;

		MerkleTree t2 = new MerkleTree();      // Merkle Tree with just 4 nodes
		TreeNode r2 = new TreeNode(3, 7);
		t2.rootnode = r2;

		TreeNode n1 = new TreeNode(1, 2);
		n1.make_left_child(t2.rootnode);

		TreeNode n2 = new TreeNode(4, 6);
		n2.make_mid_child(t2.rootnode);

		TreeNode n3 = new TreeNode(8, 9);
		n3.make_right_child(t2.rootnode);


    	// Testcases ------------------------------------------
		MerkleTree[] tc_trees = {t0  , t1  , t1  , t2  , t2  , t2  , t2  , t2  , t2  };
		int[]        tc_keys  = { 1  ,  1  ,  3  ,  1  ,  0  ,  4  ,  5  ,  9  , 10  };
		TreeNode[]   results  = {null,  r1 , null, n1  , null, n2  , null, n3  , null};

		for (int i = 0; i < tc_trees.length; ++i) {
			System.out.println((tc_trees[i].Search(tc_keys[i]) == results[i]) ? "Test ("+i+"/"+(tc_trees.length - 1)+"): passed" : "Test ("+i+"/"+(tc_trees.length - 1)+"): failed");
		}

    }

}
