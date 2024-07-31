Consider a modified scenario where the `TreeNode` class represents a node of a ternary tree. This means each node has three children — `left`, `middle` and `right`. Additionally, the data attribute `val` is an integer (instead of a string as in the Module). Finally, an integer attribute named `subtree_sum` is also added to the class. Have a look at TreeNode.java if anything is unclear.

Implement a method of class `MerkleTree` named `SubtreeSum()` that sets `subtree_sum` in each descendent Node_i of `rootnode` (including `rootnode` itself) to the sum of all values (of attribute `val`) in the subtree rooted at Node_i. Finally, return the sum stored at `rootnode`. If the tree doesn't have any node, return 0.

You are not allowed to change any existing attribute or method but may create extra ones you need within MerkleTree.java.

Submission instructions: You have to only submit MerkleTree.java inside a zip named 'EntryNumber_test3.zip' (example: 2010CS10123_test3.zip) during your lab test.
You can create a zip by:
- Windows: Right-click on the MerkleTree.java file and select Send To -> Compressed (zipped) folder.
- Linux/macOS: Run 'zip -r 2010CS10123_test3.zip MerkleTree.java' in the terminal inside the folder that contains your MerkleTree.java file. Please make sure you change the entry number in the given command to your own entry number.