using System;

public class Lambda
{
    public void M1()
    {
        Func<int, string> f1 = (int x) => x.ToString();
        var f2 = (int x) => x.ToString();
    }
}

