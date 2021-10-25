using System;
using System.Diagnostics;

public class D
{
    private bool maybe;
    public bool flag;
    public D(bool b, bool f)
    {
        this.maybe = b;
        this.flag = f;
    }

    public void Caller()
    {
        Callee1(new object());
        Callee1(null);
        Callee2(new object());
    }

    public void Callee1(object param)
    {
        param.ToString(); // BAD (maybe)
    }

    public void Callee2(object param)
    {
        if (param != null)
        {
            param.ToString(); // GOOD
        }
        param.ToString(); // BAD (maybe)
    }

    private static bool CustomIsNull(object x)
    {
        if (x is string) return false;
        if (x == null) return true;
        return x == null;
    }

    public void NullGuards()
    {
        var o1 = maybe ? null : new object();
        if (o1 != null) o1.ToString(); // GOOD

        var o2 = maybe ? null : "";
        if (o2 is string) o2.ToString(); // GOOD

        object o3 = null;
        if ((o3 = maybe ? null : "") != null)
            o3.ToString(); // GOOD

        var o4 = maybe ? null : "";
        if ((2 > 1 && o4 != null) != false)
            o4.ToString(); // GOOD

        var o5 = (o4 != null) ? "" : null;
        if (o5 != null)
            o4.ToString(); // GOOD
        if (o4 != null)
            o5.ToString(); // GOOD (false positive)

        var o6 = maybe ? null : "";
        if (!CustomIsNull(o6))
            o6.ToString(); // GOOD

        var o7 = maybe ? null : "";
        var ok = o7 != null && 2 > 1;
        if (ok)
            o7.ToString(); // GOOD
        else
            o7.ToString(); // BAD (maybe)

        var o8 = maybe ? null : "";
        int track = o8 == null ? 42 : 1 + 1;
        if (track == 2)
            o8.ToString(); // GOOD
        if (track != 42)
            o8.ToString(); // GOOD
        if (track < 42)
            o8.ToString(); // GOOD (false positive)
        if (track <= 41)
            o8.ToString(); // GOOD (false positive)
    }

    public void Deref(int i)
    {
        int[] xs = maybe ? null : new int[2];
        if (i > 1)
            xs[0] = 5; // BAD (maybe)

        if (i > 2)
            maybe = xs[1] > 5; // BAD (maybe)

        if (i > 3)
        {
            var l = xs.Length; // BAD (maybe)
        }

        if (i > 4)
            foreach (var _ in xs) ; // BAD (maybe)

        if (i > 5)
            lock (xs) // BAD (maybe)
                xs.ToString(); // Not reported - same basic block

        if (i > 6)
        {
            Debug.Assert(xs != null);
            xs[0] = xs[1]; // GOOD
        }
    }

    public void F(bool b)
    {
        var x = b ? null : "abc";
        x = x == null ? "" : x;
        if (x == null)
            x.ToString(); // BAD (always)
        else
            x.ToString(); // GOOD
    }

    public void LengthGuard(int[] a, int[] b)
    {
        int alen = a == null ? 0 : a.Length; // GOOD
        int blen = b == null ? 0 : b.Length; // GOOD
        var sum = 0;
        if (alen == blen)
        {
            for (int i = 0; i < alen; i++)
            {
                sum += a[i]; // GOOD (false positive)
                sum += b[i]; // GOOD (false positive)
            }
        }
        int alen2;
        if (a != null)
            alen2 = a.Length; // GOOD
        else
            alen2 = 0;
        for (int i = 1; i <= alen2; ++i)
        {
            sum += a[i - 1]; // GOOD (false positive)
        }
    }

    public void MissedGuard(object obj)
    {
        obj.ToString(); // BAD (maybe)
        var x = obj != null ? 1 : 0;
    }

    private object MkMaybe()
    {
        if (maybe) throw new Exception();
        return new object();
    }

    public void Exceptions()
    {
        object obj = null;
        try
        {
            obj = MkMaybe();
        }
        catch (Exception e)
        {
        }
        obj.ToString(); // BAD (maybe)

        object obj2 = null;
        try
        {
            obj2 = MkMaybe();
        }
        catch (Exception e)
        {
            Debug.Assert(false);
        }
        obj2.ToString(); // GOOD

        object obj3 = null;
        try
        {
            obj3 = MkMaybe();
        }
        finally { }
        obj3.ToString(); // GOOD
    }

    public void ClearNotNull()
    {
        var o = new Object();
        if (o == null)
            o.ToString(); // BAD (always)
        o.ToString(); // GOOD

        try
        {
            MkMaybe();
        }
        catch (Exception e)
        {
            if (e == null)
                e.ToString(); // BAD (always)
            e.ToString(); // GOOD
        }

        object n = null;
        var o2 = n == null ? new Object() : n;
        o2.ToString(); // GOOD

        var o3 = "abc";
        if (o3 == null)
            o3.ToString(); // BAD (always)
        o3.ToString(); // GOOD

        var o4 = "" + null;
        if (o4 == null)
            o4.ToString(); // BAD (always)
        o4.ToString(); // GOOD
    }

    public void CorrelatedConditions(bool cond, int num)
    {
        object o = null;
        if (cond)
            o = new Object();
        if (cond)
            o.ToString(); // GOOD

        o = null;
        if (flag)
            o = "";
        if (flag)
            o.ToString(); // GOOD

        o = null;
        var other = maybe ? null : "";
        if (other == null)
            o = "";
        if (other != null)
            o.ToString(); // BAD (always) (reported as maybe)
        else
            o.ToString(); // GOOD (false positive)

        var o2 = (num < 0) ? null : "";
        if (num < 0)
            o2 = "";
        else
            o2.ToString(); // GOOD (false positive)
    }

    public void TrackingVariable(int[] a)
    {
        object o = null;
        object other = null;
        if (maybe)
        {
            o = "abc";
            other = "def";
        }

        if (other is string)
            o.ToString(); // GOOD (false positive)

        o = null;
        int count = 0;
        var found = false;
        for (var i = 0; i < a.Length; i++)
        {
            if (a[i] == 42)
            {
                o = ((int)a[i]).ToString();
                count++;
                if (2 > i) { }
                found = true;
            }
            if (a[i] > 10000)
            {
                o = null;
                count = 0;
                if (2 > i) { }
                found = false;
            }
        }

        if (count > 3)
            o.ToString(); // GOOD (false positive)

        if (found)
            o.ToString(); // GOOD (false positive)

        object prev = null;
        for (var i = 0; i < a.Length; ++i)
        {
            if (i != 0)
                prev.ToString(); // GOOD (false positive)
            prev = a[i];
        }

        string s = null;
        {
            var s_null = true;
            foreach (var i in a)
            {
                s_null = false;
                s = "" + a;
            }
            if (!s_null)
                s.ToString(); // GOOD (false positive)
        }

        object r = null;
        var stat = MyStatus.INIT;
        while (stat == MyStatus.INIT && stat != MyStatus.READY)
        {
            r = MkMaybe();
            if (stat == MyStatus.INIT)
                stat = MyStatus.READY;
        }
        r.ToString(); // GOOD (false positive)
    }

    public enum MyStatus
    {
        READY,
        INIT
    }

    public void G(object obj)
    {
        string msg = null;
        if (obj == null)
            msg = "foo";
        else if (obj.GetHashCode() > 7) // GOOD
            msg = "bar";

        if (msg != null)
        {
            msg += "foobar";
            throw new Exception(msg);
        }
        obj.ToString(); // GOOD
    }

    public void LoopCorr(int iters)
    {
        int[] a = null;
        if (iters > 0)
            a = new int[iters];

        for (var i = 0; i < iters; ++i)
            a[i] = 0; // GOOD (false positive)

        if (iters > 0)
        {
            string last = null;
            for (var i = 0; i < iters; i++)
                last = "abc";
            last.ToString(); // GOOD (false positive)
        }

        int[] b = maybe ? null : new int[iters];
        if (iters > 0 && (b == null || b.Length < iters))
            throw new Exception();

        for (var i = 0; i < iters; ++i)
        {
            b[i] = 0; // GOOD (false positive)
        }
    }

    void Test(Exception e, bool b)
    {
        Exception ioe = null;
        if (b)
            ioe = new Exception("");

        if (ioe != null)
            ioe = e;
        else
            ioe.ToString(); // BAD (always)
    }

    public void LengthGuard2(int[] a, int[] b)
    {
        int alen = a == null ? 0 : a.Length; // GOOD
        int sum = 0;
        int i;
        for (i = 0; i < alen; i++)
        {
            sum += a[i]; // GOOD (false positive)
        }
        int blen = b == null ? 0 : b.Length; // GOOD
        for (i = 0; i < blen; i++)
        {
            sum += b[i]; // GOOD (false positive)
        }
        i = -3;
    }

    public void CorrConds2(object x, object y)
    {
        if ((x != null && y == null) || (x == null && y != null))
            return;
        if (x != null)
            y.ToString(); // GOOD (false positive)
        if (y != null)
            x.ToString(); // GOOD (false positive)
    }
}
