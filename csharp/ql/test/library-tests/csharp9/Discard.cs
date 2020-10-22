using System;

public class Class1
{
    public void M1()
    {
        Func<int, int> i = (_) => 42;
        i = (int _) => 42;
        i = delegate (int _) { return 0; };
    }
}