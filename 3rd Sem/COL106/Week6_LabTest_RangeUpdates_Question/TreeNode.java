public class TreeNode{
	public TreeNode parent;
	public TreeNode left;
	public TreeNode right;
	public int key;
	public int partial_val;
	public int var1;
	public int var2;

	//This constructor helps initialize a new TreeNode object. 
	//You do not need to use this
	TreeNode(TreeNode parent, int key){
		this.key = key;
		this.parent = parent;
		this.partial_val = 0;
	}
}