using System;

public class Class1
{
    public void M1()
    {
        [Obsolete]
        int? dup([System.Diagnostics.CodeAnalysis.NotNullWhen(true)] bool b, int? i)
        {
            return 2 * i;
        }

        dup(true, 42);

        static extern void localExtern();
    }
}
