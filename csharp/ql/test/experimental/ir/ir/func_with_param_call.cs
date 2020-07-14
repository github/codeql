using System;  

public class test_call_with_param 
{
    public static int f(int x, int y) 
    {
        return x + y;
    }

    public static int g() 
    {
        return f(2, 3);
    }
}
