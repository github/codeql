using System;
using System.Diagnostics;
using Microsoft.VisualStudio.TestTools.UnitTesting;

class AssertTests
{
    void Fn()
    {
        string s = null;
        Debug.Assert(s != null);
        Console.WriteLine(s.Length);

        Assert.IsNull(s);
        Console.WriteLine(s.Length); // always null

        Assert.IsNotNull(s);
        Console.WriteLine(s.Length);

        Assert.IsTrue(s == null);
        Console.WriteLine(s.Length); // always null

        Assert.IsTrue(s != null);
        Console.WriteLine(s.Length);

        Assert.IsFalse(s != null);
        Console.WriteLine(s.Length); // always null

        Assert.IsFalse(s == null);
        Console.WriteLine(s.Length);
    }
}

// semmle-extractor-options: ${testdir}/../../resources/stubs/Microsoft.VisualStudio.TestTools.UnitTesting.cs
