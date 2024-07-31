import Includes.*;
import java.util.*;
import java.io.*;

public class DriverCode{

	public static void main(String[] args)
    {

		// Construct trees as in testcases.txt

		MerkleTree t0 = new MerkleTree();      
		TreeNode r0 = new TreeNode(null, -1);
		t0.rootnode = r0;
		r0.left = new TreeNode(r0, 1);


		MerkleTree t1 = new MerkleTree();      
		TreeNode r1 = new TreeNode(null, -1);
		t1.rootnode = r1;
		r1.left = new TreeNode(r1, 1);
		r1.right = new TreeNode(r1, 2);

		MerkleTree t2 = new MerkleTree();      
		TreeNode r2 = new TreeNode(null, -1);
		t2.rootnode = r2;
		TreeNode n1 = new TreeNode(r2, -1);
		r2.left = n1;
		r2.right = new TreeNode(r2, 3);
		n1.left = new TreeNode(n1, 1);
		n1.right = new TreeNode(n1, 2);

		MerkleTree t3 = new MerkleTree();      
		TreeNode r3 = new TreeNode(null, -1);
		t3.rootnode = r3;
		TreeNode n2 = new TreeNode(r3, -1);
		TreeNode n3 = new TreeNode(r3, -1);
		r3.left = n2;
		r3.right = n3;
		n2.left = new TreeNode(n2, 2);
		n2.right = new TreeNode(n2, 6);
		n3.left = new TreeNode(n3, 8);
		n3.right = new TreeNode(n3, 10);
		
		MerkleTree t4 = new MerkleTree();      
		TreeNode r4 = new TreeNode(null, -1);
		t4.rootnode = r4;
		TreeNode n4 = new TreeNode(r4, -1);
		TreeNode n5 = new TreeNode(r4, -1);
		TreeNode n6 = new TreeNode(n4, -1);
		TreeNode n7 = new TreeNode(n4, -1);
		TreeNode n8 = new TreeNode(n5, -1);
		TreeNode n9 = new TreeNode(n5, -1);
		r4.left = n4;
		r4.right = n5;
		n4.left = n6;
		n4.right = n7;
		n5.left = n8;
		n5.right = n9;
		n6.left = new TreeNode(n6, 0);
		n6.right = new TreeNode(n6, 2);
		n7.left = new TreeNode(n7, 4);
		n7.right = new TreeNode(n7, 5);
		n8.left = new TreeNode(n8, 7);
		n8.right = new TreeNode(n8, 9);
		n9.left = new TreeNode(n9, 10);
		n9.right = new TreeNode(n9, 13);
		
		// Perform updates and point queries

		Boolean[] tc = new Boolean[11];
		Arrays.fill(tc, Boolean.FALSE);

		t0.RangeUpdate(r0.left, r0.left, 2);
		tc[0] = t0.GetLeafValue(r0.left) == 2;

		t1.RangeUpdate(r1.left, r1.left, 2);
		t1.RangeUpdate(r1.right, r1.right, 3);
		t1.RangeUpdate(r1.left, r1.right, 1);
		tc[1] = t1.GetLeafValue(r1.left) == 3;
		tc[2] = t1.GetLeafValue(r1.right) == 4;

		t2.RangeUpdate(n1.left, r2.right, -2);
		t2.RangeUpdate(n1.right, r2.right, 5);
		tc[3] = t2.GetLeafValue(n1.left) == -2;
		tc[4] = t2.GetLeafValue(n1.right) == 3;
		
		t3.RangeUpdate(n2.left, n3.right, 4);
		t3.RangeUpdate(n3.left, n3.right, -2);
		tc[5] = t3.GetLeafValue(n2.right) == 4;
		tc[6] = t3.GetLeafValue(n3.right) == 2;

		t4.RangeUpdate(n7.right, n9.right, 5);
		t4.RangeUpdate(n6.right, n8.right, 2);
		t4.RangeUpdate(n6.left, n9.right, -1);
		tc[7] = t4.GetLeafValue(n6.left) == -1;
		tc[8] = t4.GetLeafValue(n7.left) == 1;
		tc[9] = t4.GetLeafValue(n7.right) == 6;
		tc[10] = t4.GetLeafValue(n9.right) == 4;

		for(int i=0; i<tc.length; i++){
			System.out.println("cr");
			System.out.println("Test case "+i+"/"+tc.length + ": "  + (tc[i]?"passed":"failed"));
		}
    }

}
