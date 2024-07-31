public class TreeNode {

	// Pointers to other nodes ---
	public TreeNode parent;
	public TreeNode leftchild;
	public TreeNode midchild;
	public TreeNode rightchild;

	// Data in current node: each node always has 2 values ----
	public int val1;
	public int val2;

	// You do not need to use anything after this point -------------------------------------------

	TreeNode(int _val1, int _val2) {

		if (!(_val1 < _val2)) {
			System.out.println("***** Invalid TreeNode parameters " + _val1 + " " + _val2 + " *****");
			return;
		}

		this.val1 = _val1;
		this.val2 = _val2;
	}

	public void make_left_child(TreeNode _parent) {

		if (!(this.val2 < _parent.val1)) {
			System.out.println("***** Invalid left_child *****");
			return;
		}

		_parent.leftchild = this;
		this.parent = _parent;
	}

	public void make_mid_child(TreeNode _parent) {

		if (!(_parent.val1 < this.val1) || !(this.val2 < _parent.val2)) {
			System.out.println("***** Invalid mid_child *****");
			return;
		}

		_parent.midchild = this;
		this.parent = _parent;
	}

	public void make_right_child(TreeNode _parent) {

		if (!(_parent.val2 < this.val1)) {
			System.out.println("***** Invalid right_child *****");
			return;
		}

		_parent.rightchild = this;
		this.parent = _parent;
	}

}