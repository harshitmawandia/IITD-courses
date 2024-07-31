Implement a method of class `AuthList` named `Delete2ndLast()` that assumes that the list has not been tampered with and deletes the second last node of the list (make sure to update all necessary pointers in all AuthList and Node objects). In case there is no second last node in the list throw a NodeDoesNotExistException. Update the digests in whichever nodes necessary (you will need to create a CRF object with outputsize=64 for this). Finally, return the new proof of the AuthList (the digest of the last node).

Note that you are also provided with the implementation of `InsertNode` and can use it if required.


Submission instructions: You have to only submit AuthList.java inside a zip named 'EntryNumber_test2.zip' (example: 2010CS10123_test2.zip) during your lab test.
You can create a zip by:
- Windows: Right-click on the AuthList.java file and select Send To -> Compressed (zipped) folder.
- Linux/macOS: Run 'zip -r 2010CS10123_test1.zip AuthList.java' in the terminal inside the folder that contains your AuthList.java file. Please make sure you change the entry number in the given command to your own entry number.