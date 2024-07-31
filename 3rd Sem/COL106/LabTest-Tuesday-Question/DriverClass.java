import HelperClasses.Pair;

class DriverClass
{
    public static void main(String args[]) throws Exception
    {
        // CRF

        CRF CRF_obj = new CRF(4);


	System.out.println("String x = \"5E884898DA28047151D0E56F8DC6292773603D0D6AABBDD62A11EF721D1542D8\" \n"); 

	String x = "5E884898DA28047151D0E56F8DC6292773603D0D6AABBDD62A11EF721D1542D8";

	String s2 = CRF_obj.Fn_2(x);
	
	System.out.println("Output of Fn_2(x) : " + s2 + "\n");
	
	
	Pair<String, String> p = CRF_obj.FindColl_Fn_2(x);
        
        try {
            if(p==null || p.first.equals(p.second) || !CRF_obj.Fn_2(p.first).equals(CRF_obj.Fn_2(p.second)))
                throw new AssertionError();
            System.out.println("CRF ran successfully!");
            System.out.println("First string: " + p.first + "\n");
            System.out.println("Second string: " + p.second + "\n");
        }
        catch (AssertionError e) {
            System.err.println("CRF failed!");
        }

    }
}
