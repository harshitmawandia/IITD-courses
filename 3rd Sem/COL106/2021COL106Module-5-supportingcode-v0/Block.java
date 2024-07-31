import Includes.*;

public class Block{
	public MerkleTree mtree;
	/*
		Data has a String attribute, you can set the value of which
		in the constructor or using some other function

		For more reference see the Data.java file
	*/
	public Block previous;
	public Block next;
	public String dgst;
	public int year;
	public String value;
}
