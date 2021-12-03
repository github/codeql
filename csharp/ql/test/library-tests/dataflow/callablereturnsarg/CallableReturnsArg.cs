using System;

class CallableReturnsArg
{
    public static T NotNull<T>(T x)
    {
        if (x == null)
        {
            throw new NullReferenceException();
        }
        return x;
    }

    public static T WrapNotNull<T>(T x)
    {
        var res = NotNull(x);
        Console.WriteLine("Logged: " + res);
        return res;
    }

    public static int Add(int x, int y)
    {
        return x + y;
    }

    public Func<int, string, int> ProjFst = (x, y) => x;

    public Func<int, string, object> ProjSndWrap = (x, y) => typeof(CallableReturnsArg).GetMethod("NotNull").Invoke(null, new object[] { NotNull(y) });

    public static T IdOut<T>(T x, out T y) where T : class
    {
        if (x == default(T)) { y = null; } else { y = x; }
        return y;
    }

    public static T IdRef<T>(T x, ref T y)
    {
        y = x;
        return y;
    }

    public static T NonIdOut<T>(T x, out T y)
    {
        y = x;
        y = default(T);
        return y;
    }

    public static T NonIdRef<T>(T x, ref T y)
    {
        y = x;
        y = default(T);
        return y;
    }

    public static T Apply<T>(Func<T, T> f, Func<T, T> g, T x)
    {
        var y = f(NotNull(x)); // non-locally resolvable delegate call
        Func<T, T> wrap = w => w;
        var z = wrap(y); // locally resolvable delegate call
        return g(NotNull(z));
    }

    public static string ApplyPreserving1(string s)
    {
        return Apply(x => x + "", x => x, s);
    }

    public static string ApplyPreserving2(string s)
    {
        return Apply(NotNull, x => x, s);
    }

    public static string ApplyNonPreserving1(string s)
    {
        return Apply(_ => "42", x => x, s);
    }

    public static string ApplyNonPreserving2(string s)
    {
        return Apply(x => x, _ => "42", s);
    }

    /*
     * Since delegate call resolution only tracks backwards
     * through the last call (in this case `Apply`), the
     * following three methods are all wrongly marked.
     * This is the usual performance vs precision trade off...
     */
    public static T ApplyWrapper<T>(Func<T, T> f, Func<T, T> g, T x)
    {
        return Apply(f, g, x);
    }

    public static string ApplyNonPreservingFP1(string s)
    {
        return ApplyWrapper(_ => "42", x => x, s);
    }

    public static string ApplyNonPreservingFP2(string s)
    {
        return ApplyWrapper(x => x, _ => "42", s);
    }

    public static string ReturnBarrier(string s)
    {
        if (s == null)
            return s;
        return "";
    }

    public static string ReturnNoBarrier(string s)
    {
        if (s != null)
            return s;
        return "";
    }
}
