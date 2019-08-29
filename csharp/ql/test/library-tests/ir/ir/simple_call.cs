using System;  

public class test_simple_call 
{
    public static int f() 
    {
        return 0;
    }

    public int g() 
    {
        return f();
    }
}
