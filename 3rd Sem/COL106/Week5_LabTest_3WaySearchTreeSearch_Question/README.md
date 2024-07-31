Consider a modified `TreeNode` class where:

1. instead of the `String data` attribute we have: two integers `int val1` and `int val2`
2. along with `leftchild` and `rightchild` we also have a `midchild`

For every node in the Merkel Tree the following conditions hold:

1. node.val1 < node.val2
2. All values in the node.leftchild < node.leftval
3. node.leftval < All values in the node.midchild < node.rightval
4. node.righttval < All values in the node.rightchild

Implement a method of class `MerkleTree` named `Search(int key)` that returns node of the tree that contains the key, if no node contains the key then returns nulll.
Assume that values (`val1` and `val2`) in all the nodes are distinct.

You are not allowed to change any existing attribute or method but may create extra ones you need within MerkleTree.java.

Testcases and their outputs are available in testcases.txt.

Submission instructions: You have to only submit MerkleTree.java inside a zip named 'EntryNumber_test5.zip' (example: 2018CS10385_test5.zip) during your lab test.
You can create a zip by:
- Windows: Right-click on the MerkleTree.java file and select Send To -> Compressed (zipped) folder.
- Linux/macOS: Run 'zip -r 2018CS10385_test5.zip MerkleTree.java' in the terminal inside the folder that contains your MerkleTree.java file. Please make sure you change the entry number in the given command to your own entry number.


