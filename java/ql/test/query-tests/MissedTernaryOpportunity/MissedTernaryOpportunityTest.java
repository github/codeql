import java.util.*;

public class MissedTernaryOpportunityTest {

	public static boolean missedOpportunity1(int a){
		if(a == 42)
			return true;
		else
			return false;
	}

	public static boolean doNotComplain1(int a){		
		if(a == 42){
			return true;
		}else{
			System.out.println("output");
			return false;
		}
	}

	public static boolean doNotComplain2(int a){		
		if(a == 42){
			System.out.println("output");
			return true;
		}else{
			return false;
		}
	}

	public static boolean missedOpportunity2(int a){
		boolean ret;
		if(a == 42)
			ret = true;
		else
			ret = false;
		return ret;
	}
	
	public static boolean doNotComplain3(int a){		
		boolean ret;
		String someOutput;
		if(a == 42){
			ret = true;
			someOutput = "yes";
		}else{
			someOutput = "nope";
			ret = false;
		}
		System.out.println(someOutput);
		return ret;
	}

	// complex condition
	public static boolean doNotComplain4(int a){
		boolean ret;
		if(a == 42 || a % 2 == 0)
			ret = true;
		else
			ret = false;
		return ret;
	}

	// complex condition
	public static boolean doNotComplain5(int a){
		boolean ret;
		if(a > 42 && a % 2 == 0)
			ret = true;
		else
			ret = false;
		return ret;
	}

	public static boolean missedOpportunity3(int a){
        if(a == 42)
            return true;
        else
            return someOtherFn(a);
    }

    // nested function call
	public static boolean doNotComplain6(int a){
        if(a == 42)
            return true;
        else
            return someOtherFn(someFn(a));
    }

    // nested function call
	public static boolean doNotComplain7(int a){
        if(a == 42)
            return someOtherFn(someFn(a));
        else
            return true;
    }

    // nested ConditionalExpr
	public static boolean doNotComplain8(int a){
        if(a > 42)
            return a == 55 ? true : false;
        else
            return true;
    }
	
    private String memberVar1 = "hello";
    private String memberVar2 = "hello";

    // no assignment
	public void doNotComplain9(int a){
        if(a > 42)
            System.out.println(memberVar1);
        else
            System.out.println(memberVar1 + "5");
    }

    // assignment to two different member variables
	public void doNotComplain10(int a){
        if(a > 42)
            this.memberVar1 = "hey";
        else
            this.memberVar2 = "hey";
    }

    // same variable names, but different variables (different qualifiers)
	public void doNotComplain11(int a){
        if(a > 42)
            this.memberVar1 = "hey";
        else
            SomeBogusClass.memberVar1 = "ho";
    }

    // same variables, different qualification
	public void missedOpportunity4(int a){
        if(a > 42)
            memberVar1 = "hey";
        else
            MissedTernaryOpportunityTest.this.memberVar1 = "ho";
    }

    // nested if
    public boolean missedOpportunity5(int a){
        if(a > 42){
            System.out.println("something");
            return false;
        }else{
            if(a == 42)
                return true;
            else
                return false;
        }
    }

    // nested if
    public boolean missedOpportunity6(int a){
        if(a > 42){
            if(a == 42)
                return true;
            else
                return false;
        }else{
            System.out.println("something");
            return false;
        }
    }


    private static int someFn(int a){ return a + 5; }
    private static boolean someOtherFn(int a){ return a > 0; }

    private static class SomeBogusClass{
        public static String memberVar1 = "something";
    }
}
