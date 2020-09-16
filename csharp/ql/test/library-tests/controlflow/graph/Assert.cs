using System;
using System.Diagnostics;
using Microsoft.VisualStudio.TestTools.UnitTesting;

class AssertTests
{
    void M1(bool b)
    {
        string s = b ? null : "";
        Debug.Assert(s != null);
        Console.WriteLine(s.Length);
    }

    void M2(bool b)
    {
        string s = b ? null : "";
        Assert.IsNull(s);
        Console.WriteLine(s.Length);
    }

    void M3(bool b)
    {
        string s = b ? null : "";
        Assert.IsNotNull(s);
        Console.WriteLine(s.Length);
    }

    void M4(bool b)
    {
        string s = b ? null : "";
        Assert.IsTrue(s == null);
        Console.WriteLine(s.Length);
    }

    void M5(bool b)
    {
        string s = b ? null : "";
        Assert.IsTrue(s != null);
        Console.WriteLine(s.Length);
    }

    void M6(bool b)
    {
        string s = b ? null : "";
        Assert.IsFalse(s != null);
        Console.WriteLine(s.Length);
    }

    void M7(bool b)
    {
        string s = b ? null : "";
        Assert.IsFalse(s == null);
        Console.WriteLine(s.Length);
    }

    void M8(bool b)
    {
        string s = b ? null : "";
        Assert.IsTrue(s != null && b);
        Console.WriteLine(s.Length);
    }

    void M9(bool b)
    {
        string s = b ? null : "";
        Assert.IsFalse(s == null || b);
        Console.WriteLine(s.Length);
    }

    void M10(bool b)
    {
        string s = b ? null : "";
        Assert.IsTrue(s == null && b);
        Console.WriteLine(s.Length);
    }

    void M11(bool b)
    {
        string s = b ? null : "";
        Assert.IsFalse(s != null || b);
        Console.WriteLine(s.Length);
    }

    void M12(bool b)
    {
        string s = b ? null : "";
        Debug.Assert(s != null);
        Console.WriteLine(s.Length);

        s = b ? null : "";
        Assert.IsNull(s);
        Console.WriteLine(s.Length);

        s = b ? null : "";
        Assert.IsNotNull(s);
        Console.WriteLine(s.Length);

        s = b ? null : "";
        Assert.IsTrue(s == null);
        Console.WriteLine(s.Length);

        s = b ? null : "";
        Assert.IsTrue(s != null);
        Console.WriteLine(s.Length);

        s = b ? null : "";
        Assert.IsFalse(s != null);
        Console.WriteLine(s.Length);

        s = b ? null : "";
        Assert.IsFalse(s == null);
        Console.WriteLine(s.Length);

        s = b ? null : "";
        Assert.IsTrue(s != null && b);
        Console.WriteLine(s.Length);

        s = b ? null : "";
        Assert.IsFalse(s == null || !b);
        Console.WriteLine(s.Length);

        s = b ? null : "";
        Assert.IsTrue(s == null && b);
        Console.WriteLine(s.Length);

        s = b ? null : "";
        Assert.IsFalse(s != null || !b);
        Console.WriteLine(s.Length);
    }
}
