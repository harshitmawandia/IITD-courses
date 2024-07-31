
import java.util.*;
import HelperClasses.*;
import DSCoinPackage.*;

class Driver_true {


    public static void main(String args[]) {
	DSCoin_Honest obj = makeHonestObj(4, 8);
	// System.out.println(obj.memberlist[0]);
	Moderator mod = new Moderator();
		try {
			mod.initializeDSCoin(obj, 32);
//			System.out.println(printDSObj(obj));

		} catch (EmptyQueueException e) {
			e.printStackTrace();
		}
		for (int i = 0; i < 10; i ++){
	    obj.memberlist[i%4].initiateCoinsend(obj.memberlist[(i+1)%4].UID, obj);
	}
		try {
			obj.memberlist[0].MineCoin(obj);
		} catch (EmptyQueueException e) {
			e.printStackTrace();
		}
		for (int i = 0; i < 8; i ++){
	    if (obj.bChain.lastBlock.trarray[i].Source != null){
		try{
		    Pair<List<Pair<String, String>>, List<Pair<String, String>>> lists =  obj.bChain.lastBlock.trarray[i].Source.finalizeCoinsend(obj.bChain.lastBlock.trarray[i], obj);
		    System.out.println(printLists(lists));
		}
		catch (Exception e) {
		    System.out.println("My name is kira yoshikage, I am 33 years old");
		}
	    }
	}
	System.out.println(printDSObj(obj));
    }

    public static String printLists (Pair<List<Pair<String, String>>, List<Pair<String, String>>> lists){
	String s = "Lists: \n";
	for (int i = 0; i < lists.first.size(); i ++){
	    s += lists.first.get(i).first +  lists.first.get(i).second;
	}
	for (int i = 0; i < lists.second.size(); i ++){
	    s += lists.second.get(i).first +  lists.second.get(i).second;
	}
	return s;
    }

    public static DSCoin_Honest makeHonestObj (int memnum, int trcount){
	DSCoin_Honest obj = new DSCoin_Honest();
	obj.pendingTransactions = new TransactionQueue();
	obj.memberlist = new Members[memnum];
	for (int i = 0; i < memnum; i ++){
	    obj.memberlist[i] = new Members();
	    obj.memberlist[i].UID = "Member " + Integer.toString(i);
	    obj.memberlist[i].mycoins = new ArrayList<Pair<String,TransactionBlock>>();
	}
	obj.bChain = new BlockChain_Honest();
	obj.bChain.tr_count = trcount;
	return obj;
    }
    public static DSCoin_Malicious makeMaliciousObj (int memnum, int trcount){
	DSCoin_Malicious obj = new DSCoin_Malicious();
	obj.pendingTransactions = new TransactionQueue();
	obj.memberlist = new Members[memnum];
	for (int i = 0; i < memnum; i ++){
	    obj.memberlist[i] = new Members();
	    obj.memberlist[i].UID = "Member " + Integer.toString(i);
	}
	obj.bChain = new BlockChain_Malicious();
	obj.bChain.tr_count = trcount;
	return obj;
    }
    
    public static String printMember (Members m){
    	String s = "Member Name : ";
    	s += m.UID + "\n Member Coins \n";
    	for (Pair<String, TransactionBlock> p : m.mycoins){
    	    s += p.first + " ";
    	}
	s += "\n";
    	return s;
    }
    public static String printBlock (TransactionBlock b){
	String s = "Block Summary: ";
	s += b.trsummary + "\n Nonce ";
	if (b.nonce != null){
	    s += b.nonce + " \n dgst ";
	}
	else {
	    s += "null \n dgst ";
	}
	if (b.dgst != null){
	    s += b.dgst + "\n";
	}
	else {
	    s += "null \n";
	}
	return s;
    }
    public static String printBlockChain (BlockChain_Honest c){
	String s = "Block Chain Honest \n ";
	TransactionBlock b = c.lastBlock;
	for (; b != null; b = b.previous){
	    s += printBlock(b) + "\n";
	}
	return s;
    }
    public static String printBlockChain (BlockChain_Malicious c){
	String s = "Block Chain Malicious \n";
	List<TransactionBlock> l = new ArrayList<>();
	for (int i = 0; i < c.lastBlocksList.length; i ++){
	    if (c.lastBlocksList[i] != null){
		l.add(c.lastBlocksList[i]);
	    }
	}
	for (int i = 1; i < l.size(); i ++){
	    for (int j = i; j > 0 && l.get(j).trsummary.compareTo(l.get(j-1).trsummary) <= 0; j --){
		TransactionBlock temp = l.get(j);
		l.set(j, l.get(j-1));
		l.set(j-1, temp);
	    }
	}
	for (int i = 0; i < l.size(); i ++){
	    for (TransactionBlock b = l.get(i); b != null; b = b.previous){
		s += printBlock(b) + "\n";
	    }
	}
	return s;
    }
    public static String printDSObj (DSCoin_Honest o){
	String s = "Honest Obj latest coin : ";
	s += o.latestCoinID + " \n Block Chain : \n";
	s += printBlockChain(o.bChain) + "memberlist \n";
	for (int i = 0; i < o.memberlist.length; i ++){
	    s += printMember(o.memberlist[i]);
	}
	return s;
    }
    public static String printDSObj (DSCoin_Malicious o){
	String s = "Malicious Obj latest coin : ";
	s += o.latestCoinID + " \n Block Chain : \n";
	s += printBlockChain(o.bChain) + "memberlist \n";
	for (int i = 0; i < o.memberlist.length; i ++){
	    s += printMember(o.memberlist[i]);
	}
	return s;
    }
}
