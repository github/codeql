using System;
using System.Collections.Generic;
using System.Linq;

public class E
{
    public void Ex1(long[][][] a1, int ix, int len)
    {
        long[][] a2 = null;
        var haveA2 = ix < len && (a2 = a1[ix]) != null;
        long[] a3 = null;
        var haveA3 = haveA2 && (a3 = a2[ix]) != null; // GOOD (FALSE POSITIVE)
        if (haveA3)
            a3[0] = 0; // GOOD (FALSE POSITIVE)
    }

    public void Ex2(bool x, bool y)
    {
        var s1 = x ? null : "";
        var s2 = (s1 == null) ? null : "";
        if (s2 == null)
        {
            s1 = y ? null : "";
            s2 = (s1 == null) ? null : "";
        }
        if (s2 != null)
            s1.ToString(); // GOOD (FALSE POSITIVE)
    }

    public void Ex3(IEnumerable<string> ss)
    {
        string last = null;
        foreach (var s in new string[] { "aa", "bb" })
            last = s;
        last.ToString(); // GOOD

        last = null;
        if (ss.Any())
        {
            foreach (var s in ss)
                last = s;

            last.ToString(); // GOOD
        }
    }

    public void Ex4(IEnumerable<string> list, int step)
    {
        int index = 0;
        var result = new List<List<string>>();
        List<string> slice = null;
        var iter = list.GetEnumerator();
        while (iter.MoveNext())
        {
            var str = iter.Current;
            if (index % step == 0)
            {
                slice = new List<string>();
                result.Add(slice);
            }
            slice.Add(str); // GOOD (FALSE POSITIVE)
            ++index;
        }
    }

    public void Ex5(bool hasArr, int[] arr)
    {
        int arrLen = 0;
        if (hasArr)
            arrLen = arr == null ? 0 : arr.Length;

        if (arrLen > 0)
            arr[0] = 0; // GOOD (FALSE POSITIVE)
    }

    public const int MY_CONST_A = 1;
    public const int MY_CONST_B = 2;
    public const int MY_CONST_C = 3;

    public void Ex6(int[] vals, bool b1, bool b2)
    {
        int switchguard;
        if (vals != null && b1)
            switchguard = MY_CONST_A;
        else if (vals != null && b2)
            switchguard = MY_CONST_B;
        else
            switchguard = MY_CONST_C;

        switch (switchguard)
        {
            case MY_CONST_A:
                vals[0] = 0; // GOOD
                break;
            case MY_CONST_C:
                break;
            case MY_CONST_B:
                vals[0] = 0; // GOOD
                break;
            default:
                throw new Exception();
        }
    }

    public void Ex7(int[] arr1)
    {
        int[] arr2 = null;
        if (arr1.Length > 0)
            arr2 = new int[arr1.Length];

        for (var i = 0; i < arr1.Length; i++)
            arr2[i] = arr1[i]; // GOOD (FALSE POSITIVE)
    }

    public void Ex8(int x, int lim)
    {
        bool stop = x < 1;
        int i = 0;
        var obj = new object();
        while (!stop)
        {
            int j = 0;
            while (!stop && j < lim)
            {
                int step = (j * obj.GetHashCode()) % 10; // GOOD (FALSE POSITIVE)
                if (step == 0)
                {
                    obj.ToString(); // GOOD
                    i += 1;
                    stop = i >= x;
                    if (!stop)
                    {
                        obj = new object();
                    }
                    else
                    {
                        obj = null;
                    }
                    continue;
                }
                j += step;
            }
        }
    }

    public void Ex9(bool cond, object obj1)
    {
        if (cond)
        {
            return;
        }
        object obj2 = obj1;
        if (obj2 != null && obj2.GetHashCode() % 5 > 2)
        {
            obj2.ToString(); // GOOD
            cond = true;
        }
        if (cond)
            obj2.ToString(); // GOOD (FALSE POSITIVE)
    }

    public void Ex10(int[] a)
    {
        int n = a == null ? 0 : a.Length;
        for (var i = 0; i < n; i++)
        {
            int x = a[i]; // GOOD (FALSE POSITIVE)
            if (x > 7)
                a = new int[n];
        }
    }

    public void Ex11(object obj, bool b1)
    {
        bool b2 = obj == null ? false : b1;
        if (b2 == null)
        {
            obj.ToString(); // GOOD (FALSE POSITIVE)
        }
        if (obj == null)
        {
            b1 = true;
        }
        if (b1 == null)
        {
            obj.ToString(); // GOOD (FALSE POSITIVE)
        }
    }

    public void Ex12(object o)
    {
        var i = o.GetHashCode(); // BAD (maybe)
        var s = o?.ToString();
    }

    public void Ex13(bool b)
    {
        var o = b ? null : "";
        o.M1(); // GOOD
        if (b)
            o.M2(); // BAD (maybe)
        else
            o.Select(x => x); // BAD (maybe)
    }

    public int Ex14(string s)
    {
        if (s is string)
            return s.Length;
        return s.GetHashCode(); // BAD (always)
    }

    public void Ex15(bool b)
    {
        var x = "";
        if (b)
            x = null;
        x.ToString(); // BAD (maybe)
        if (b)
            x.ToString(); // BAD (always)
    }

    public void Ex16(bool b)
    {
        var x = "";
        if (b)
            x = null;
        if (b)
            x.ToString(); // BAD (always)
        x.ToString(); // BAD (maybe)
    }

    public int Ex17(int? i)
    {
        return i.Value; // BAD (maybe)
    }

    public int Ex18(int? i)
    {
        return (int)i; // BAD (maybe)
    }

    public int Ex19(int? i)
    {
        if (i.HasValue)
            return i.Value; // GOOD
        return -1;
    }

    public int Ex20(int? i)
    {
        if (i != null)
            return i.Value; // GOOD
        return -1;
    }

    public int Ex21(int? i)
    {
        if (i == null)
            i = 0;
        return i.Value; // GOOD
    }

    public void Ex22()
    {
        object o = null;
        try
        {
            o = Make();
            o.ToString(); // GOOD
        }
        finally
        {
            if (o != null)
                o.ToString(); // GOOD
        }
    }

    public void Ex23(bool b)
    {
        if (b)
            b.ToString();
        var o = Make();
        o?.ToString();
        o.ToString(); // BAD (maybe)
        if (b)
            b.ToString();
    }

    public void Ex24(bool b)
    {
        string s = b ? null : "";
        if (s?.M2() == 0)
        {
            s.ToString(); // GOOD
        }
    }

    public void Ex25(object o)
    {
        var s = o as string;
        s.ToString(); // BAD (maybe)
    }

    private long? l;
    public long Long { get => l ?? 0; set { l = value; } }
    public void Ex26(E e)
    {
        if (l.HasValue)
        {
            e.Long = l.Value; // GOOD
        }
        return;
    }

    public bool Field;
    string Make() => Field ? null : "";

    static void Ex27(string s1, string s2)
    {
        if ((s1 ?? s2) is null)
        {
            s1.ToString(); // BAD (always)
            s2.ToString(); // BAD (always)
        }
    }

    static void Ex28()
    {
        var x = (string)null ?? null;
        x.ToString(); // BAD (always)
    }

    static void Ex29(string s)
    {
        var x = s ?? "";
        x.ToString(); // GOOD
    }

    static void Ex30(string s, object o)
    {
        var x = s ?? o as string;
        x.ToString(); // BAD (maybe)
    }

    static void Ex31(string s, object o)
    {
        dynamic x = s ?? o as string;
        x.ToString(); // BAD (maybe)
    }

    static void Ex32(string s, object o)
    {
        dynamic x = s ?? o as string;
        if (x != null)
            x.ToString(); // GOOD
    }

    static void Ex33(string s, object o)
    {
        var x = s ?? o as string;
        if (x != (string)null)
            x.ToString(); // GOOD
    }

    static int Ex34(string s = null) => s.Length; // BAD (maybe)

    static int Ex35(string s = "null") => s.Length; // GOOD

    static int Ex36(object o)
    {
        if (o is string)
        {
            var s = o as string;
            return s.Length; // GOOD (FALSE POSITIVE)
        }
        return -1;
    }

    static bool Ex37(E e1, E e2)
    {
        if ((e1 == null && e2 != null) || (e1 != null && e2 == null))
            return false;
        if (e1 == null && e2 == null)
            return true;
        return e1.Long == e2.Long; // GOOD (FALSE POSITIVE)
    }

    int Ex38(int? i)
    {
        i ??= 0;
        return i.Value; // GOOD
    }

    System.Drawing.Color Ex39(System.Drawing.Color? color)
    {
        color ??= System.Drawing.Color.White;
        return color.Value; // GOOD
    }

    int Ex40()
    {
        int? i = null;
        i ??= null;
        return i.Value; // BAD (always)
    }

    int Ex41()
    {
        int? i = 1;
        i ??= null;
        return i.Value; // GOOD
    }

    static bool Ex42(int? i, IEnumerable<int> @is)
    {
        return @is.Any(j => j == i.Value); // BAD (maybe)
    }

    static bool Ex43(int? i, IEnumerable<int> @is)
    {
        if (i.HasValue)
            return @is.Any(j => j == i.Value); // GOOD
        return false;
    }

    static bool Ex44(int? i, IEnumerable<int> @is)
    {
        if (i.HasValue)
            @is = @is.Where(j => j == i.Value); // BAD (always) (FALSE NEGATIVE)
        i = null;
        return @is.Any();
    }
}

public static class Extensions
{
    public static void M1(this string s) { }
    public static int M2(this string s) => s.Length;
}
