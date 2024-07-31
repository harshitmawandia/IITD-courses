import Includes.*;
import java.util.*;
import java.io.*;

public class DriverCode{

	public static void main(String[] args)
    {
		// Add your own code here to verify `CalculateMedian`
		int[] L = {1, 2, 3,4,5,5,6,6,4,4,3,434,34,34,34,34,34,43,21};
		System.out.println(L.length);
		int median = Statistics.CalculateMedian(L);
		System.out.println(median);

		return;
    }
}
