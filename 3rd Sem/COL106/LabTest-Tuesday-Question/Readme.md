Q. A variation of CRF.Fn() is provided to you as CRF.Fn_2(). The output of Fn_2() is defined to be 64 characters long in which the first 60 characters are taken directly as the first 60 characters of the input string, and the last 4 characters are the output of the Fn() function on the remaining input string. Example: if x = y.concat(z) where y is a 60 character string, then Fn_2(x) = y.concat(Fn(z)). 
Take a look at the implementation in CRF.java for better understanding.

Given Fn_2(), implement a function FindColl_Fn_2(String s) that takes a 60 character string s as input, and will return 2 strings such that both strings have s as the prefix, and Fn_2()'s output on them is the same.

Note: You have to only submit CRF.java inside a zip named as 'EntryNumber_test1.zip' (example: 2010CS10123_test1.zip) during your lab test.
You can create a zip by:
- Windows: Right-click on the CRF.java file and select Send To -> Compressed (zipped) folder.
- Linux/MaxOs: Run 'zip -r 2010CS10123_test1.zip CRF.java' in the terminal inside the folder that contains your CRF.java file. Please make sure you change the entry number in the given command to your own entry number.
