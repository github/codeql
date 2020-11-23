using System;

public class Class1
{
    public void M1(int j, uint k)
    {
        nint x = j;
        nint x0 = (nint)j;
        IntPtr x1 = (IntPtr)j;
        nuint y = k;

        const nint i = (nint)42;
    }

    public void M2()
    {
        nint x = 3;
        int y = 3;
        long v = 10;

        var test3 = typeof(nint);      // System.IntPtr
        var test4 = typeof(nuint);     // System.UIntPtr
        var test5 = (x + 1).GetType(); // System.IntPtr
        var test6 = (x + y).GetType(); // System.IntPtr
        var test7 = (x + v).GetType(); // System.Int64
    }
}