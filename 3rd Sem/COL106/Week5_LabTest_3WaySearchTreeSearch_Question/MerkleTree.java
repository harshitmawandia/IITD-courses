import Includes.*;
import java.util.*;

public class MerkleTree {

	// Check the TreeNode.java file for more details
	public TreeNode rootnode;

    /*==========================
    |- To be done by students -|
    ==========================*/
    /* Lab test to-do */

	public TreeNode Search(int key) {
		
		TreeNode cr = rootnode;

		while(cr!=null){
			if(cr.val1==key || cr.val2 == key){
				return cr;
			}else{
				if(key<cr.val1){
					cr=cr.leftchild;
				}else if(key>cr.val2){
					cr=cr.rightchild;
				}else{
					cr = cr.midchild;
				}
			}
		}
		

		return null;
	}
}
