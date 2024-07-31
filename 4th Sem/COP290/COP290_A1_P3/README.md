
# Task 1: Subtask 3

Hierarchical code design, creating library and API:

## Steps to run the program

1. type _. /opt/intel/oneapi/setvars.sh --force_ on the command line
    It sets the tbbroot environment variable

2. LD_LIBRARY_PATH should be defined before execution

3. Type _make_ on the command line.
> It compiles all the code of the directory. 
  audioTester.cpp is converted to executable: yourcode.out 

4. Make sure, the extracted features are in a .txt file in mfcc_features directory

5. The command format  is given below:
     *./yourcode.out mfcc_features/exctracted_features.txt out.txt* 

6. Type the necessary code format in the command line to execute.

7. Input audiosamplefile followed by the top 3 keywords with highest softmax probabilities are appended in the end of out.txt

