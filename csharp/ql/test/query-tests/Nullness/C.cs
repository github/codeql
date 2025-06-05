using System;
using System.Collections.Generic;
using System.Diagnostics;
using Microsoft.VisualStudio.TestTools.UnitTesting;

public class C
{
    public void NotTest()
    {
        object o = null;
        if (!(!(!(o == null))))
        {
            o.GetHashCode(); // GOOD
        }

        if (!(o != null))
        {
            o.GetHashCode(); // $ Alert[cs/dereferenced-value-is-always-null]
        }
    }

    public void AssertNull(object o)
    {
        if (o != null)
            throw new Exception("not null");
    }

    static bool IsNull(object o) => o == null;

    static bool IsNotNull(object o) => o != null;

    public void AssertNonNull(object o)
    {
        if (o == null)
            throw new Exception("null");
    }

    public void AssertTest()
    {
        var s = Maybe() ? null : "";
        Debug.Assert(s == null);
        s.ToString(); // $ Alert[cs/dereferenced-value-is-always-null]

        s = Maybe() ? null : "";
        Debug.Assert(s != null);
        s.ToString(); // GOOD
    }

    public void AssertNullTest()
    {
        var o1 = new object();
        AssertNull(o1);
        o1.ToString(); // $ MISSING: Alert[cs/dereferenced-value-is-always-null]

        var o2 = Maybe() ? null : "";
        Assert.IsNull(o2);
        o2.ToString(); // $ Alert[cs/dereferenced-value-is-always-null]
    }

    public void AssertNotNullTest()
    {
        var o1 = Maybe() ? null : new object(); // $ Source[cs/dereferenced-value-may-be-null]
        AssertNonNull(o1);
        o1.ToString(); // $ SPURIOUS (false positive): Alert[cs/dereferenced-value-may-be-null]

        var o2 = Maybe() ? null : new object(); // $ Source[cs/dereferenced-value-may-be-null]
        AssertNonNull(o1);
        o2.ToString(); // $ Alert[cs/dereferenced-value-may-be-null]

        var o3 = Maybe() ? null : new object();
        Assert.IsNotNull(o3);
        o3.ToString(); // GOOD
    }

    public void TestNull()
    {
        object o = null;
        if (IsNotNull(o))
            o.ToString(); // GOOD

        if (!IsNull(o))
            o.ToString(); // GOOD
    }

    public void InstanceOf()
    {
        object o = null;
        if (o is string)
            o.ToString(); // GOOD
    }

    public void Lock()
    {
        var o = Maybe() ? null : new object(); // $ Source[cs/dereferenced-value-may-be-null]
        lock (o) // $ Alert[cs/dereferenced-value-may-be-null]
            o.ToString(); // GOOD
    }

    public void Foreach(IEnumerable<int> list)
    {
        if (Maybe())
            list = null; // $ Source[cs/dereferenced-value-may-be-null]
        foreach (var x in list) // $ Alert[cs/dereferenced-value-may-be-null]
        {
            x.ToString(); // GOOD
            list.ToString(); // GOOD
        }
    }

    public void Conditional()
    {
        string colours = null;
        var colour = colours == null || colours.Length == 0 ? "Black" : colours.ToString(); // GOOD
    }

    public void Simple()
    {
        string[] children = null;
        var comparator = "";
        if (children == null)
            children = new string[0];
        if (children.Length > 1) { } // GOOD
    }

    public void AssignIf()
    {
        string xx;
        String ok = null;
        if ((ok = (xx = null)) == null || ok.Length > 0) // GOOD
            ;
    }

    public void AssignIf2()
    {
        bool Foo(string o) => false;
        string ok2 = null;
        if (Foo(ok2 = "hello") || ok2.Length > 0) // GOOD
            ;
    }

    public void AssignIfAnd()
    {
        string xx;
        string ok3 = null;
        if ((xx = (ok3 = null)) != null && ok3.Length > 0) // GOOD
            ;
    }

    public void DoWhile()
    {
        var s = "";
        do
        {
            s.ToString(); // GOOD
            s = null;
        }
        while (s != null);

        s = null;
        do
        {
            s.ToString(); // $ Alert[cs/dereferenced-value-is-always-null]
            s = null;
        }
        while (s != null);

        s = null;
        do
        {
            s.ToString(); // $ Alert[cs/dereferenced-value-is-always-null]
        }
        while (s != null);

        s = "";
        do
        {
            s.ToString(); // $ Alert[cs/dereferenced-value-may-be-null]
            s = null; // $ Source[cs/dereferenced-value-may-be-null]
        }
        while (true);
    }

    public void While()
    {
        var s = "";
        while (s != null)
        {
            s.ToString(); // GOOD
            s = null;
        }

        var b = true;
        s = null;
        while (b)
        {
            s.ToString(); // $ Alert[cs/dereferenced-value-is-always-null]
            s = null;
        }

        s = "";
        while (true)
        {
            s.ToString(); // $ Alert[cs/dereferenced-value-may-be-null]
            s = null; // $ Source[cs/dereferenced-value-may-be-null]
        }
    }

    public void If()
    {
        var s = Maybe() ? null : "";
        if (s != null)
        {
            s.ToString(); // GOOD
            s = null;
        }

        if (s == null)
            s.ToString(); // $ Alert[cs/dereferenced-value-is-always-null]

        s = "";
        if (s != null && s.Length % 2 == 0)
            s = null; // $ Source[cs/dereferenced-value-may-be-null]
        s.ToString(); // $ Alert[cs/dereferenced-value-may-be-null]
    }

    public void For()
    {
        String s;
        for (s = ""; s != null; s = null)
        {
            s.ToString(); // GOOD
        }
        s.ToString(); // $ Alert[cs/dereferenced-value-is-always-null]

        for (s = null; s == null; s = null)
        {
            s.ToString(); // $ Alert[cs/dereferenced-value-is-always-null]
        }

        for (s = ""; ; s = null) // $ Source[cs/dereferenced-value-may-be-null]
        {
            s.ToString(); // $ Alert[cs/dereferenced-value-may-be-null]
        }
    }

    public void ArrayAssignTest()
    {
        int[] a = null;
        a[0] = 10; // $ Alert[cs/dereferenced-value-is-always-null]

        a = new int[10];
        a[0] = 42; // GOOD
    }

    public void Access()
    {
        int[] ia = null;
        string[] sa = null;

        ia[1] = 0; // $ Alert[cs/dereferenced-value-is-always-null]
        var temp = sa.Length; // $ Alert[cs/dereferenced-value-is-always-null]

        ia[1] = 0; // BAD (always), but not first
        temp = sa.Length; // BAD (always), but not first
    }

    bool m;
    C(bool m)
    {
        this.m = m;
    }

    bool Maybe() => this.m;
}
