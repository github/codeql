using System;
using System.Diagnostics;
using System.Diagnostics.Contracts;
using Microsoft.VisualStudio.TestTools.UnitTesting;

public static class Forwarders
{
    public static void MyAssert(bool b) => Assert.IsTrue(b);
    public static void MyAssert2(bool b) => MyAssert(b);
}

class Assertions
{
    void M()
    {
        string s = null;
        Debug.Assert(s != null);
        Assert.IsNull(s);
        Assert.IsNotNull(s);
        Assert.IsTrue(s == null);
        Assert.IsTrue(s != null);
        Assert.IsFalse(s != null);
        Assert.IsFalse(s == null);
        Forwarders.MyAssert(s == null);
        Forwarders.MyAssert2(s == null);
    }

    void Trivial()
    {
        Debug.Assert(false);
        Debug.Assert(true);
        Assert.IsTrue(false);
        Assert.IsTrue(true);
        Assert.IsFalse(true);
        Assert.IsFalse(false);
        Forwarders.MyAssert(false);
        Forwarders.MyAssert(true);
        Forwarders.MyAssert2(false);
        Forwarders.MyAssert2(true);
    }

    void CodeContracts(string s)
    {
        Contract.Requires(s != null);
        Contract.Requires(s != null, "s must be non-null");
        Contract.Requires<Exception>(s != null);
        Contract.Requires<Exception>(s != null, "s must be non-null");
        Contract.Assert(s != null);
        Contract.Assert(s != null, "s is non-null");
        Contract.Assume(s != null);
        Contract.Assume(s != null, "s is non-null");
    }
}

// semmle-extractor-options: ${testdir}/../../../resources/stubs/Microsoft.VisualStudio.TestTools.UnitTesting.cs /r:System.Diagnostics.Contracts.dll
