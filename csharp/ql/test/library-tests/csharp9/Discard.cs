using System;

public class Discard
{
    public void M1()
    {
        Func<int, int, int> i = (int a, int b) => 42;
        i = (_, _) => 42;
        i = (int _, int _) => 42;
        i = delegate (int _, int _) { return 0; };
    }
}
