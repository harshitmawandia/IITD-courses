package DSCoinPackage;

import HelperClasses.CRF;
import HelperClasses.TreeNode;
import HelperClasses.MerkleTree;

public class BlockChain_Malicious {

  public int tr_count;
  public static final String start_string = "DSCoin";
  public TransactionBlock[] lastBlocksList;

  public static boolean checkTransactionBlock (TransactionBlock tB) {
    CRF crf= new CRF(64);
    if(!tB.dgst.substring(0,4).equals("0000"))
    {
        return false;
    }
    if(tB.previous==null){
      if(!tB.dgst.equals(crf.Fn(start_string + "#" + tB.trsummary + "#" + tB.nonce))){
          return false;
      }
    }
    else if(!tB.dgst.equals(crf.Fn(tB.previous.dgst + "#" + tB.trsummary + "#" + tB.nonce))){
      return false;
    }
    MerkleTree merkleTree = new MerkleTree();
    if(!(tB.trsummary.equals(merkleTree.Build(tB.trarray)))){
      return false;
    }
    for(int i=0; i<tB.trarray.length;i++){
      if(!tB.checkTransaction(tB.trarray[i])){
        return false;
      }
    }
    return true;
  }

  public TransactionBlock FindLongestValidChain () {
    int i1=0;
    TransactionBlock block=new TransactionBlock(null);
    TransactionBlock cr;
    TransactionBlock transactionBlock;
    for (TransactionBlock transactionBlock1 : lastBlocksList) {
      int i = 0;
      cr = transactionBlock1;
      transactionBlock = cr;
      while (cr != null) {
        i++;
        if (!checkTransactionBlock(cr)) {
          i = 0;
          transactionBlock = cr.previous;
        }
        cr = cr.previous;
      }
      if (i >= i1) {
        i1 = i;
        block = transactionBlock;
      }
    }
    return block;
  }//this

  public void InsertBlock_Malicious (TransactionBlock block1) {
    TransactionBlock block=FindLongestValidChain();
    String s;
    if(block==null)s=start_string;
    else s=block.dgst;
    CRF obj= new CRF(64);
    int i=1000000000;
    while(!((obj.Fn(s + "#"+ block1.trsummary+"#"+ ++i)).startsWith("0000")));
    block1.nonce=Integer.toString(i);
    block1.dgst=obj.Fn(s + "#"+ block1.trsummary+"#"+ i);
    int i1=1;
    for(int j=0;j<lastBlocksList.length;j++){
      if(lastBlocksList[j]==block){
        lastBlocksList[j]=block1;
        i1=0;
        break;
      }
    }
    if(i1==1){
      for(int j = 0;j< lastBlocksList.length;j++){
          if(lastBlocksList[j]==null){
              lastBlocksList[j] = block1;
              i1=0;
          }
      }
    }
    if(i1==1){
      TransactionBlock[] array = new TransactionBlock[lastBlocksList.length+1];
      for(int j = 0; j< lastBlocksList.length;j++){
        array[j] = lastBlocksList[j];
      }
      array[lastBlocksList.length]= block1;
      lastBlocksList = array;
    }
  }
}
