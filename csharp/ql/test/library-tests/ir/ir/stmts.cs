using System;

public class test_stmts {
    public static int ifStmt(int x) {
        if (x == 5)
            return 0;
        else
            return 1;
    }

    public static void whileStmt(int x) {
        int i = 0;
        while (i < 10) {
            x = x + 1;
        }
    }

    public static int switchStmt(int y) {
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

    public static void tryCatchFinally() {
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
        catch {
            throw;
        }
        finally
        {
            x = 2;
        }
    }
    
}
