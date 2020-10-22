using System;

public class Class1
{
    public void M1()
    {
        void m(Func<int, int> f) { }

        const int z = 10;
        m(static x => x + z);
    }
}