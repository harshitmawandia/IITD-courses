import Includes.*;
import java.util.*;
//import javafx.util.Pair;

public class MerkleTree {

	public class Pair<A, B>{
		public A First;
		public B Second;
		public Pair(){

		}
		public Pair(A _first, B _second) {
			this.First = _first;
			this.Second = _second;
		}
		public A get_first() {
			return First;
		}
		public B get_second() {
			return Second;
		}
	}

	// Check the TreeNode.java file for more details
	public TreeNode rootnode;

	public Pair<ArrayList<TreeNode>, ArrayList<TreeNode>> LowestCommonAncestor(TreeNode node1, TreeNode node2){
		ArrayList<TreeNode> path1, path2;
		path1 = new ArrayList<TreeNode>();
		path2 = new ArrayList<TreeNode>();
		TreeNode ptr1 = node1, ptr2 = node2;
		while(ptr1 != null){
			path1.add(ptr1);
			ptr1 = ptr1.parent;
		}
		while(ptr2 != null){
			path2.add(ptr2);
			ptr2 = ptr2.parent;
		}
		int m = path1.size();
		int n = path2.size();

		Collections.reverse(path1);
		Collections.reverse(path2);

		int lca_idx=Math.min(m,n)-1;
		for(int i=0; i<Math.min(m,n); i++){
			if(path1.get(i) != path2.get(i)){
				lca_idx = i-1;
				break;
			}
		}

		while(lca_idx > 0){
			path1.remove(0);
			path2.remove(0);
			lca_idx--;
		}
		
		Collections.reverse(path1);
		Collections.reverse(path2);
		
		return new Pair<ArrayList<TreeNode>, ArrayList<TreeNode>>(path1, path2);
	}
	
    /*==========================
    |- To be done by students -|
    ==========================*/
    /* Lab test to-do */

	public int GetLeafValue(TreeNode leaf) {
		
		TreeNode cr = leaf;
		int sum = 0;
		while(cr.parent!=null){
			sum+=cr.partial_val;
		}


		return sum;
	}

	public void RangeUpdate(TreeNode lower, TreeNode upper, int increment_val){
		
		Pair<ArrayList<TreeNode>, ArrayList<TreeNode>> p = LowestCommonAncestor(lower, upper);
		ArrayList<TreeNode> path_lower = p.First;
		ArrayList<TreeNode> path_upper = p.Second;

		TreeNode cr= lower;
		lower.partial_val+=increment_val;
		for(int i=0;i<path_lower.size();i++){
			if(path_lower.get(i).right!=null && path_lower.get(i).right!=cr){
				path_lower.get(i).right.partial_val+=increment_val;
			}
			cr=cr.parent;

		}

		cr = upper;
		upper.partial_val+=increment_val;
		for(int i=0;i<path_upper.size();i++){
			if(path_upper.get(i).left!=null && path_upper.get(i).left!=cr){
				path_upper.get(i).left.partial_val+=increment_val;
			}
			cr=cr.parent;
		}

	}
}