using System;

public class test_stmts 
{
    public static int ifStmt(int x) 
    {
        if (x == 5)
            return 0;
        else
            return 1;
    }

    public static void whileStmt(int x) 
    {
        int i = 0;
        while (i < 10) 
        {
            x = x + 1;
        }
    }

    public static int switchStmt() 
    {
        object caseSwitch = new object();
        int select = 0;

        switch (caseSwitch)
        {
            case -1:
                goto case true;
            case 0: 
                goto case "123";
            case "123":
                select = 100;
                break;
            case true:
                select = 101;
                goto default;
            default:
                return select;
        }
        return 0;
    }

    public static void tryCatchFinally() 
    {
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
        catch 
        {
            throw;
        }
        finally
        {
            x = 2;
        }
    }
    
    public static void forStmt() 
    {
        int x = 0;
        for (int i = 0, j = 10; i < j; i++, j--)
        {   
            x = x - 1; 
        }
        
        int a, b = 10;
        for (a = 0; a < b; ) 
        {
            a++;
        }

        for( ; ; )
        {

        }
    }    
    
    public static void doWhile() 
    {
        int x = 0;
        do
        {
            x = x + 1;
        }
        while (x < 10);
    }
    
    public static void checkedUnchecked()
    {
        int num = Int32.MaxValue;
        unchecked
        {
            num = num + 1;
        }
        checked
        {
            num = num + 1;
        }    
    }
}
