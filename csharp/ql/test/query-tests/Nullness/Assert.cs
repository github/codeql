using System;
using System.Diagnostics;
using Microsoft.VisualStudio.TestTools.UnitTesting;

class AssertTests
{
    void Fn(bool b)
    {
        string s = b ? null : "";
        Debug.Assert(s != null);
        Console.WriteLine(s.Length); // GOOD

        s = b ? null : "";
        Assert.IsNull(s);
        Console.WriteLine(s.Length); // BAD (always)

        s = b ? null : "";
        Assert.IsNotNull(s);
        Console.WriteLine(s.Length); // GOOD

        s = b ? null : "";
        Assert.IsTrue(s == null);
        Console.WriteLine(s.Length); // BAD (always)

        s = b ? null : "";
        Assert.IsTrue(s != null);
        Console.WriteLine(s.Length); // GOOD

        s = b ? null : "";
        Assert.IsFalse(s != null);
        Console.WriteLine(s.Length); // BAD (always)

        s = b ? null : "";
        Assert.IsFalse(s == null);
        Console.WriteLine(s.Length); // GOOD

        s = b ? null : "";
        Assert.IsTrue(s != null && b);
        Console.WriteLine(s.Length); // GOOD

        s = b ? null : "";
        Assert.IsFalse(s == null || !b);
        Console.WriteLine(s.Length); // GOOD

        s = b ? null : "";
        Assert.IsTrue(s == null && b);
        Console.WriteLine(s.Length); // BAD (always)

        s = b ? null : "";
        Assert.IsFalse(s != null || !b);
        Console.WriteLine(s.Length); // BAD (always)
    }
}

// semmle-extractor-options: ${testdir}/../../resources/stubs/Microsoft.VisualStudio.TestTools.UnitTesting.cs
