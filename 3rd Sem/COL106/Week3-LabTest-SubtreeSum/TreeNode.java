public class TreeNode{
	public TreeNode parent;
	public TreeNode left;
	public TreeNode middle;
	public TreeNode right;
	public int val;
	public int subtree_sum;

	//This constructor helps initialize a new TreeNode object. 
	//You do not need to use this
	TreeNode(TreeNode parent, int val){
		this.val = val;
		this.parent = parent;
	}
}