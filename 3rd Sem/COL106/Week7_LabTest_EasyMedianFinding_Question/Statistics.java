import Includes.*;
import java.util.*;

public class 		Statistics {
	
    /*==========================
    |- To be done by students -|
    ==========================*/
    /* Lab test to-do */

    public static void FindFrequency(int[] A, int[] L){
    	for(int i=0; i < L.length; i++){
    		A[L[i]]++;
    	}
    }

	public static int CalculateMedian(int[] L) {
		
		int[] A = new int[100000];
		for(int i=0;i<100000;i++){
			A[i] = 0;
		}

		FindFrequency(A,L);

		int sum = 0;
		for(int i = 0; i < A.length; i++){
			sum+=A[i];
			if(sum>=(L.length + 1)/2){
				return i;
			}
		}
		
		return -1;
	}
}