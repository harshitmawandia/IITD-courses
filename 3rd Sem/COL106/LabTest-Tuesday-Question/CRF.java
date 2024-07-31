import java.util.*;

import HelperClasses.Pair;
import HelperClasses.sha256;

public class CRF extends sha256 {

    // Stores the output size of the function Fn()
    public int outputsize;

    CRF(int size) {
        outputsize = size;
        assert outputsize <= 64;
    }

    // Outputs the mapped outputSize characters long string s' for an input string s
    public String Fn(String s) {
        String shasum = encrypt(s);
        return shasum.substring(0,outputsize);
    }

    /* Lab test Fn_2() */
    public String Fn_2(String s) {
        String shasum = s.substring(0, 64-outputsize) + Fn(s.substring(64-outputsize, s.length()));
        return shasum;
    }

    /*==========================
    |- To be done by students -|
    ==========================*/
    

    /* Lab test to-do */
    /* Implement your code here */
    public Pair<String, String> FindColl_Fn_2(String prefix) {

		HashMap<String,String> map = new HashMap<>();
        String s = "";
        for (int i=0;i<4
;i++){
            s+="0";
        }

        while (true){
            String key = Fn(s);
            if(map.get(key)==null){
                map.put(key,s);
                s=key;
            }else{
                Pair<String,String> pair = new Pair<String,String>(prefix.substring(0,60)+s,prefix.substring(0,60)+map.get(key));
                return pair;
            }
        }

		
    }

	
}
