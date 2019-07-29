using System;

public class test_stmts {
    public static int test_if(int x) {
        if (x == 5)
            return 0;
        else
            return 1;
    }

    public static void test_while(int x) {
        int i = 0;
        while (i < 10) {
            x = x + 1;
        }
    }

    public static int test_switch(int y) {
        int caseSwitch = 1;
        int select = 0;
      
        switch (caseSwitch)
        {
            case -1:
            case 0:
                break;
            case 1:
                select = 100;
                break;
            case 2:
                select = 101;
                goto default;
            default:
                return select;
        }
        select = 1000;
        return 0;
    }
    
    public static void test_trycatchfinally() {
        int x = 5;
        try
        {
            if (x != 0)
                throw (new System.Exception());
            x = 0;
        }
        catch(System.Exception ex)
        {
            x = 1;
        }
        finally
        {
            x = 2;
        }
    }
}
