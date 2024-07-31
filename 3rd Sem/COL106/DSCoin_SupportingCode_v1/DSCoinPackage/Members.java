package DSCoinPackage;

import java.util.*;
import HelperClasses.*;
// import DSCoinPackage.Transaction;
// import DSCoinPackage.TransactionBlock;
// import DSCoinPackage.DSCoin_Honest;
// import DSCoinPackage.DSCoin_Malicious;
// import DSCoinPackage.MissingTransactionException;

public class Members
{

    public String UID;
    public List<Pair<String, TransactionBlock>> mycoins;
    public Transaction[] in_process_trans;

    public void initiateCoinsend(String destUID, DSCoin_Honest DSobj) {
        Transaction transaction = new Transaction();
        transaction.coinID = mycoins.get(0).first;
        transaction.coinsrc_block = mycoins.get(0).second;
        transaction.Source = this;
        for(Members members : DSobj.memberlist){
            if(members.UID.equals(destUID)){
                transaction.Destination=members;
            }
        }
        Transaction[] temp = new Transaction[in_process_trans.length+1];
        for(int i = 0; i < in_process_trans.length;i++){
            temp[i] = in_process_trans[i];
        }
        temp[in_process_trans.length]=transaction;
        in_process_trans = temp;
        TransactionQueue queue = DSobj.pendingTransactions;
        queue.AddTransactions(transaction);
    }

    public void initiateCoinsend(String destUID, DSCoin_Malicious DSobj) {
        Transaction transaction = new Transaction();
        transaction.coinID = mycoins.get(0).first;
        transaction.coinsrc_block = mycoins.get(0).second;
        transaction.Source = this;
        for(Members members : DSobj.memberlist){
            if(members.UID.equals(destUID)){
                transaction.Destination=members;
            }
        }
        Transaction[] temp = new Transaction[in_process_trans.length+1];
        for(int i = 0; i < in_process_trans.length;i++){
            temp[i] = in_process_trans[i];
        }
        temp[in_process_trans.length]=transaction;
        in_process_trans = temp;
        TransactionQueue queue = DSobj.pendingTransactions;
        queue.AddTransactions(transaction);
    }

    public Pair<List<Pair<String, String>>, List<Pair<String, String>>> finalizeCoinsend (Transaction tobj, DSCoin_Honest DSObj) throws MissingTransactionException {
        return null;
    }

    public void MineCoin(DSCoin_Honest DSObj) {

    }

    public void MineCoin(DSCoin_Malicious DSObj) {

    }
}
