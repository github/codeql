using System;
using System.Diagnostics;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Microsoft.VisualStudio.TestTools.UnitTesting
{
    public static class Assert
    {
        public static void IsNull(object o) { }
        public static void IsNotNull(object o) { }
        public static void IsTrue(bool b) { }
        public static void IsFalse(bool b) { }
    }
}

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
