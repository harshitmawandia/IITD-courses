import Includes.*;
import java.util.*;
import java.io.*;


public class DriverCode{
	public static void main(String args[]){
		String summary1 = null;
		MerkleTree tree1 = new MerkleTree();
		System.out.println("Testcases for InsertDocument:\n ");
		System.out.println("Testcase 1: ");
		summary1 = tree1.InsertDocument("Data Structures and Algorithms");
		summary1 = tree1.InsertDocument("COL106");
		summary1 = tree1.InsertDocument("This is Module 4");

		System.out.println("The summary after building Balanced Merkle tree is: "+summary1);
		System.out.println("The expected summary is: FD7CEB85D89F4F0E6D17EAEF83E11200E912B701DCE298A8559F1D49133A5D5C");
		
		if(summary1.equals("FD7CEB85D89F4F0E6D17EAEF83E11200E912B701DCE298A8559F1D49133A5D5C")){
			System.out.println("Testcase 1/3 Passed!\n");
		}
		else{
			System.out.println("Testcase 1/3 Failed!\n");
		}
		
		
		System.out.println("Testcase 2:");
		MerkleTree tree2 = new MerkleTree();
		String summary2 = null;
		
		summary2 = tree2.InsertDocument("T");
		summary2 = tree2.InsertDocument("H!");
		summary2 = tree2.InsertDocument("C");
		summary2 = tree2.InsertDocument("D");
		
		
		System.out.println("The summary after building Balanced Merkle tree is: "+summary2);
		System.out.println("The expected summary is: 649CE608E83470B4C081846B0F04D5C8C462D0B84CC2E303F02CD44637A8B5C0");
		

		if(summary2.equals("649CE608E83470B4C081846B0F04D5C8C462D0B84CC2E303F02CD44637A8B5C0")){
			System.out.println("Testcase 2/3 Passed!\n");
		}
		else{
			System.out.println("Testcase 2/3 Failed!\n");
		}	
		
		System.out.println("Testcase 3:");
		MerkleTree tree3 = new MerkleTree();
		String summary3 = null;
		
		summary3 = tree3.InsertDocument("COL106");
		summary3 = tree3.InsertDocument("Data Structures and Algorithms");
		summary3 = tree3.InsertDocument("This is Module 4");
		summary3 = tree3.InsertDocument("Hello!");
		
		System.out.println("The summary after building Balanced Merkle tree is: "+summary3);
		System.out.println("The expected summary is: B6E9442D126D3F219E714B979A946BFA9C1A41C830355BF7781DBEEA578B901C");
		

		if(summary3.equals("B6E9442D126D3F219E714B979A946BFA9C1A41C830355BF7781DBEEA578B901C")){
			System.out.println("TestCase 3/3 Passed!\n");
		}
		else{
			System.out.println("TestCase 3/3 Failed!\n");
		}	
		
	}

}
