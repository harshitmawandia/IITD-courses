package DSCoinPackage;
import HelperClasses.*;
// import DSCoinPackage.TransactionBlock;

public class BlockChain_Malicious {

    public int tr_count;
    public static final String start_string = "DSCoin";
    public TransactionBlock[] lastBlocksList;

    public static boolean checkTransactionBlock (TransactionBlock tB) {
        CRF crf = new CRF(64);
        if(!tB.dgst.substring(0,4).matches("0000")){
            return false;
        }else if(!tB.dgst.matches(crf.Fn((tB.previous!=null? tB.previous.dgst:start_string)+"#"+tB.trsummary+"#"+tB.nonce))){
            return false;
        }else {
            MerkleTree tree = new MerkleTree();
            String correct = tree.Build(tB.trarray);
            if(!tB.trsummary.equals(correct)){
                return false;
            }else{
                for(Transaction transaction : tB.trarray){
                    if(!tB.checkTransaction(transaction)){
                        return false;
                    }
                }
                return true;
            }
        }
    }

    public TransactionBlock FindLongestValidChain () {
        int maxOverAll = 0;
        TransactionBlock lastOfTheLongest = null;
        for(TransactionBlock transactionBlock:lastBlocksList){
            int max = 0; int counter = 0;
            TransactionBlock lastOfTheCurrentLongest = null; TransactionBlock counterBlock = null;
            TransactionBlock currentBlock = transactionBlock;
            while (currentBlock!=null){
                if(checkTransactionBlock(currentBlock)){
                    if(counter==0){
                        counterBlock = currentBlock;
                    }
                    counter++;
                }else{
                    if(counter>max){
                        max = counter;
                        lastOfTheCurrentLongest = counterBlock;
                    }
                    counter=0;
//                  counterBlock=null;
                }
                currentBlock=currentBlock.previous;
            }
            if(max>maxOverAll){
                maxOverAll=max;
                lastOfTheLongest=lastOfTheCurrentLongest;
            }
        }
        return lastOfTheLongest;
    }

    public void InsertBlock_Malicious (TransactionBlock newBlock) {
        TransactionBlock lastBlock = FindLongestValidChain();

        CRF crf = new CRF(64);

        newBlock.previous = lastBlock;

        if(newBlock.previous==null){
            newBlock.nonce = calcNonce(start_string, newBlock.trsummary);
            newBlock.dgst = crf.Fn(start_string+"#"+newBlock.trsummary+"#"+newBlock.nonce);
        }else{
            newBlock.nonce = calcNonce(newBlock.previous.dgst, newBlock.trsummary);
            newBlock.dgst = crf.Fn(newBlock.previous.dgst+"#"+newBlock.trsummary+"#"+newBlock.nonce);
        }

        TransactionBlock[] temp = new TransactionBlock[lastBlocksList.length+1];
        for(int i = 0; i< lastBlocksList.length;i++){
            temp[i] = lastBlocksList[i];
        }
        temp[lastBlocksList.length]= newBlock;
        lastBlocksList = temp;

    }

    public String calcNonce(String prev_dgst, String trsummary){
        long counter = 1000000001L;
        CRF crf = new CRF(64);
        while (true){
            String s = crf.Fn(prev_dgst+"#"+trsummary+"#"+counter);
            if(s.substring(0,4).matches("0000")){
                return Long.toString(counter);
            }
        }
    }
}
