Consider a modified `TreeNode` class where:

1. Instead of the `String data` attribute we have integers `int key` and `int partial_val`
2. The tree is used to store (key,value) pairs where each key is stored as a leaf node in the tree (in its `key` attribute)
3. The leaves are sorted from left to right in ascending order based on their `key` attribute (see the example below)
4. The leaf nodes of the tree store the keys in the tree in the `key` attribute
5. The value corresponding to a key (leaf node) is equal to the sum of the `partial_val` attributes of all the nodes in the path from the leaf containing that key to the root. (see example below)
6. The `key` attribute in any non-leaf node is meaningless and can be ignored.

Note: This tree is NOT a BST. It only has the property that the key values in the leaves are sorted from left to right

You are required to implement two functions which run in O(h) time, where h is the height of the tree:
1. `GetLeafValue(TreeNode leaf)`: this should get the value associated with the key `leaf.key` (as in point 5 above)
2. `RangeUpdate(TreeNode lower, TreeNode upper, int increment_val)`: this should increment the value of all keys (as returned by GetValueLeaf()) in the range [`lower.key`, `upper.key`]. This can be done efficiently by updating the partial_val attributes of certain nodes as follows:
   1. If lower == upper, then increment lower.partial_val and stop
   2. Otherwise, increment lower.partial_val and upper.partial_val and do the below.
   3. Let the lowest common ancestor of lower and upper be lca_node and the path from both leaves to the root be: path_lower = [lower, n_1, n_2, ..., n_N, lca_node] and path_upper = [upper, m_1, m_2, ..., m_M, lca_node].
   4. for w in [n_1, n_2, ..., n_N]: if w.right is not in path_lower, increment w.right.partial_val;
   5. for w in [m_1, m_2, ..., m_M]: if w.left is not in path_upper, increment w.left.partial_val;

The paths path_lower and path_upper described above have been computed for you and you can use them directly. Also, Assume that all keys (leaf nodes) are distinct.

Example: The following is one of the test cases described in testcases.txt

                r4 
               / \
              /   \
             /     \
            /       \
           /         \
          /           \
         /             \
        n4             n5
       / \            / \
      /   \          /   \
     /     \        /     \
    n6     n7      n8     n9
   / \     / \    / \    / \
  0   2   4   5  7   9  10  13

On calling GetLeafValue(7), the partial_val attributes of the nodes {7, n8, n5, r4} are to be summed and returned.
On calling RangeUpdate(5,13,x), the nodes to be updated are {5, n8, 10, 13}. Since n8 lies on the path from both 7 and 9 to the root, incrementing n8 simultaneously updates the values of both 7 and 9.

You are not allowed to change any existing attribute or method but may create extra ones you need within MerkleTree.java.

Submission instructions: You have to only submit MerkleTree.java inside a zip named 'EntryNumber_test6.zip' (example: 2018CS10385_test6.zip) during your lab test.
You can create a zip by:
- Windows: Right-click on the MerkleTree.java file and select Send To -> Compressed (zipped) folder.
- Linux/macOS: Run 'zip -r 2018CS10385_test6.zip MerkleTree.java' in the terminal inside the folder that contains your MerkleTree.java file. Please make sure you change the entry number in the given command to your own entry number.