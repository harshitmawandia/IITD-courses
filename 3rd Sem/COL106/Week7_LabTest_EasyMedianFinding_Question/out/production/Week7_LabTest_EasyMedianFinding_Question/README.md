In the file `Statistics.java`, write a function `CalculateMedian(int[] L)` that takes an integer array `L` of n numbers, where n is odd, and **efficiently** returns their median. Recall, the median of an array is a number k in the array such that at most n/2 elements in the array are smaller than k, and at most n/2 elements in the array are greater than k. Each number in the array will be a positive integer less than 100000. The function should run in linear time, ie, O(n). To do this, follow the algorithm described below.

Algorithm: 
1. Initialize an array A of size 100000. Initially, A[i] = 0 for all i. 
2. Define a method called FindFrequency(A, L). For each i in the range 0 to 100000, this method computes the number of times i appears in the list L, and stores it in A[i]. 
3. After calling FindFrequency(A, L), use the array A to find the median element of L.


There are no test cases in `DriverCode.java` this time so feel free to add your own code to test the function you write. Some examples that demonstrate the expected working of the function are given below.

Examples: 
L = (3, 1, 1, 2, 2)
Output: 2

L = (5, 2, 4, 1, 1, 7, 2)
Output: 2

You are not allowed to change any existing attributes or methods but may create extra ones you need within Statistics.java.

Submission instructions: You have to only submit Statistics.java inside a zip named 'EntryNumber_test7.zip' (example: 2018CS10385_test7.zip) during your lab test.
You can create a zip by:
- Windows: Right-click on the Statistics.java file and select Send To -> Compressed (zipped) folder.
- Linux/macOS: Run 'zip -r 2018CS10385_test7.zip Statistics.java' in the terminal inside the folder that contains your Statistics.java file. Please make sure you change the entry number in the given command to your own entry number.