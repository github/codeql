using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

/// <summary>
/// All (tainted) sinks are named `sink[Param|Field|Property]N`, for some N, and all
/// non-sinks are named `nonSink[Param|Field|Property]N`, for some N.
/// Both sinks and non-sinks are passed to the method `Check` for convenience in the
/// test query.
/// </summary>
public class DataFlow
{
    public void M()
    {
        // Static field, tainted
        Test.SinkField0 = "taint source";
        Check(Test.SinkField0);

        // Static field, not tainted
        Test.NonSinkField0 = "not tainted";
        Check(Test.NonSinkField0);

        // Static property, tainted
        Test.SinkProperty0 = Test.SinkField0;
        Check(Test.SinkProperty0);

        // Static property, not tainted
        Test.NonSinkProperty0 = Test.NonSinkField0;
        Check(Test.NonSinkProperty0);
        Test.NonSinkProperty1 = Test.SinkField0;
        Check(Test.NonSinkProperty1);

        // Flow into a callable (non-delegate), tainted
        In0(Test.SinkProperty0);
        var methodInfo = typeof(DataFlow).GetMethod("In1");
        var args = new object[] { Test.SinkProperty0 };
        methodInfo.Invoke(null, args);

        // Flow into a callable (non-delegate), not tainted
        NonIn0("");

        // Flow into a callable (delegate, locally resolvable), tainted
        Action<string> in2 = sinkParam2 => Check(sinkParam2);
        in2(Test.SinkProperty0);

        // Flow into a callable (delegate, locally resolvable), not tainted
        Action<string> nonIn1 = nonSinkParam1 => Check(nonSinkParam1);
        nonIn1("");

        // Flow into a callable (delegate, resolvable via call), tainted
        Apply(In3, Test.SinkProperty0);
        Apply(x => In4(x), Test.SinkProperty0);
        ApplyDelegate(new MyDelegate(In5), Test.SinkProperty0);
        ApplyDelegate(In6, Test.SinkProperty0);
        myDelegate = new MyDelegate(x => In7(x));
        ApplyDelegate(myDelegate, Test.SinkProperty0);

        // Flow into a callable (delegate, resolvable via call), not tainted
        Apply(nonSinkParam0 => Check(nonSinkParam0), "not tainted");
        ApplyDelegate(new MyDelegate(nonSinkParam0 => Check(nonSinkParam0)), "not tainted");

        // Flow into a callable (property), tainted
        InProperty = Test.SinkProperty0;

        // Flow into a callable (property), not tainted
        NonInProperty = "not tainted";

        // Flow through a callable that returns the argument (non-delegate), tainted
        var sink0 = Return(Test.SinkProperty0);
        Check(sink0);
        var sink1 = (string)typeof(DataFlow).GetMethod("Return").Invoke(null, new object[] { sink0 });
        Check(sink1);
        string sink2;
        ReturnOut(sink1, out sink2, out var _);
        Check(sink2);
        var sink3 = "";
        ReturnRef(sink2, ref sink3, ref sink3);
        Check(sink3);
        var sink13 = ((IEnumerable<string>)new string[] { sink3 }).SelectEven(x => x).First();
        Check(sink13);
        var sink14 = ((IEnumerable<string>)new string[] { sink13 }).Select(ReturnCheck).First();
        Check(sink14);
        var sink15 = ((IEnumerable<string>)new string[] { sink14 }).Zip(((IEnumerable<string>)new string[] { "" }), (x, y) => x).First();
        Check(sink15);
        var sink16 = ((IEnumerable<string>)new string[] { "" }).Zip(((IEnumerable<string>)new string[] { sink15 }), (x, y) => y).First();
        Check(sink16);
        var sink17 = ((IEnumerable<string>)new string[] { sink14 }).Aggregate("", (acc, s) => acc + s, x => x);
        Check(sink17);
        var sink18 = ((IEnumerable<string>)new string[] { "" }).Aggregate(sink14, (acc, s) => acc + s, x => x);
        Check(sink18);
        int sink21;
        Int32.TryParse(sink18, out sink21);
        Check(sink21);
        bool sink22;
        bool.TryParse(sink18, out sink22);
        Check(sink22);

        // Flow through a callable that returns the argument (non-delegate), not tainted
        var nonSink0 = Return("");
        Check(nonSink0);
        nonSink0 = (string)typeof(DataFlow).GetMethod("Return").Invoke(null, new object[] { nonSink0 });
        Check(nonSink0);
        ReturnOut("", out nonSink0, out string _);
        Check(nonSink0);
        ReturnOut(sink1, out var _, out nonSink0);
        Check(nonSink0);
        ReturnRef("", ref nonSink0, ref nonSink0);
        Check(nonSink0);
        ReturnRef(sink1, ref sink1, ref nonSink0);
        Check(nonSink0);
        nonSink0 = ((IEnumerable<string>)new string[] { nonSink0 }).SelectEven(x => x).First();
        Check(nonSink0);
        nonSink0 = ((IEnumerable<string>)new string[] { nonSink0 }).Select(x => x).First();
        Check(nonSink0);
        nonSink0 = ((IEnumerable<string>)new string[] { sink14 }).Zip(((IEnumerable<string>)new string[] { "" }), (x, y) => y).First();
        Check(nonSink0);
        nonSink0 = ((IEnumerable<string>)new string[] { "" }).Zip(((IEnumerable<string>)new string[] { sink15 }), (x, y) => x).First();
        Check(nonSink0);
        nonSink0 = ((IEnumerable<string>)new string[] { sink14 }).Aggregate("", (acc, s) => acc, x => x);
        Check(nonSink0);
        nonSink0 = ((IEnumerable<string>)new string[] { sink14 }).Aggregate("", (acc, s) => acc + s, x => "");
        Check(nonSink0);
        nonSink0 = ((IEnumerable<string>)new string[] { nonSink0 }).Aggregate(sink1, (acc, s) => s, x => x);
        Check(nonSink0);
        int nonSink2;
        Int32.TryParse(nonSink0, out nonSink2);
        Check(nonSink2);
        bool nonSink3;
        bool.TryParse(nonSink0, out nonSink3);
        Check(nonSink3);

        // Flow through a callable that returns the argument (delegate, locally resolvable), tainted
        Func<string, string> @return = x => ApplyFunc(Return, x);
        var sink4 = @return(sink3);
        Check(sink4);

        // Flow through a callable that returns the argument (delegate, locally resolvable), not tainted
        nonSink0 = @return(nonSink0);
        Check(nonSink0);

        // Flow through a callable that returns the argument (delegate, resolvable via call), tainted
        var sink5 = ApplyFunc(Return, sink4);
        Check(sink5);

        // Flow through a callable that (doesn't) return(s) the argument (delegate, resolvable via call), not tainted
        nonSink0 = ApplyFunc(Return, "");
        Check(nonSink0);
        nonSink0 = ApplyFunc(_ => "", sink5);
        Check(nonSink0);

        // Flow out of a callable (non-delegate), tainted
        var sink6 = Out();
        Check(sink6);
        string sink7;
        OutOut(out sink7);
        Check(sink7);
        var sink8 = "";
        OutRef(ref sink8);
        Check(sink8);
        var sink12 = OutYield().First();
        Check(sink12);
        var sink23 = TaintedParam(nonSink0); // even though the argument is not tainted, the parameter is considered tainted
        Check(sink23);

        // Flow out of a callable (non-delegate), not tainted
        nonSink0 = NonOut();
        Check(nonSink0);
        NonOutOut(out nonSink0);
        Check(nonSink0);
        NonOutRef(ref nonSink0);
        Check(nonSink0);
        nonSink0 = NonOutYield().First();
        Check(nonSink0);
        nonSink0 = NonTaintedParam(nonSink0);
        Check(nonSink0);

        // Flow out of a callable (delegate), tainted
        Func<string> @out = () => "taint source";
        var sink9 = @out();
        Check(sink9);

        // Flow out of a callable (delegate), not tainted
        Func<string> nonOut = () => "";
        nonSink0 = nonOut();
        Check(nonSink0);

        // Flow out of a callable (method access), tainted
        var sink10 = new Lazy<string>(Out).Value;
        Check(sink10);

        // Flow out of a callable (method access), not tainted
        nonSink0 = new Lazy<string>(NonOut).Value;
        Check(nonSink0);

        // Flow out of a callable (property), tainted
        var sink19 = OutProperty;
        Check(sink19);

        // Flow out of a callable (property), not tainted
        nonSink0 = NonOutProperty;
        Check(nonSink0);
    }

    public void M2()
    {
        IQueryable<string> tainted = new[] { "taint source" }.AsQueryable();
        IQueryable<string> notTainted = new[] { "not tainted" }.AsQueryable();
        // Flow into a callable via library call, tainted
        Func<string, string> f1 = sinkParam10 => { Check(sinkParam10); return sinkParam10; };
        System.Linq.Expressions.Expression<Func<string, string>> f2 = x => ReturnCheck2(x);
        var sink24 = tainted.Select(f1).First();
        Check(sink24);
        var sink25 = tainted.Select(f2).First();
        Check(sink25);
        var sink26 = tainted.Select(ReturnCheck3).First();
        Check(sink26);

        // Flow into a callable via library call, not tainted
        Func<string, string> f3 = nonSinkParam => { Check(nonSinkParam); return nonSinkParam; };
        System.Linq.Expressions.Expression<Func<string, string>> f4 = x => NonReturnCheck(x);
        var nonSink = notTainted.Select(f1).First();
        Check(nonSink);
        nonSink = notTainted.Select(f2).First();
        Check(nonSink);
        nonSink = notTainted.Select(f3).First();
        Check(nonSink);
        nonSink = notTainted.Select(f4).First();
        Check(nonSink);
        nonSink = notTainted.Select(ReturnCheck3).First();
        Check(nonSink);
    }

    public async void M3()
    {
        // async await, tainted
        var task = Task.Run(() => "taint source");
        var sink41 = task.Result;
        Check(sink41);
        var sink42 = await task;
        Check(sink42);

        // async await, not tainted
        task = Task.Run(() => "");
        var nonSink0 = task.Result;
        Check(nonSink0);
        var nonSink1 = await task;
        Check(nonSink1);
    }

    static void Check<T>(T x) { }

    static void In0<T>(T sinkParam0)
    {
        In0<T>(sinkParam0);
        Check(sinkParam0);
    }

    static void In1<T>(T sinkParam1)
    {
        Check(sinkParam1);
    }

    static void In3<T>(T sinkParam3)
    {
        Check(sinkParam3);
    }

    static void In4<T>(T sinkParam4)
    {
        Check(sinkParam4);
    }

    static void In5<T>(T sinkParam5)
    {
        Check(sinkParam5);
    }

    static void In6<T>(T sinkParam6)
    {
        Check(sinkParam6);
    }

    static void In7<T>(T sinkParam7)
    {
        Check(sinkParam7);
    }

    static void NonIn0<T>(T nonSinkParam0)
    {
        Check(nonSinkParam0);
    }

    static T Return<T>(T x)
    {
        var y = ApplyFunc(x0 => x0, x);
        return y == null ? default(T) : y;
    }

    static void ReturnOut<T>(T x, out T y, out T z)
    {
        y = x;
        z = default(T);
    }

    static void ReturnRef<T>(T x, ref T y, ref T z)
    {
        y = x;
    }

    static T ReturnCheck<T>(T sinkParam8)
    {
        Check(sinkParam8);
        return sinkParam8;
    }

    static T ReturnCheck2<T>(T sinkParam9)
    {
        Check(sinkParam9);
        return sinkParam9;
    }

    static T ReturnCheck3<T>(T sinkParam11)
    {
        Check(sinkParam11);
        return sinkParam11;
    }

    static T NonReturnCheck<T>(T nonSinkParam)
    {
        Check(nonSinkParam);
        return nonSinkParam;
    }

    string Out()
    {
        return "taint source";
    }

    void OutOut(out string x)
    {
        x = "taint source";
    }

    void OutRef(ref string x)
    {
        x = "taint source";
    }

    IEnumerable<string> OutYield()
    {
        yield return "";
        yield return "taint source";
        yield return "";
    }

    string NonOut()
    {
        return "";
    }

    void NonOutOut(out string x)
    {
        x = "";
    }

    void NonOutRef(ref string x)
    {
        x = "";
    }

    IEnumerable<string> NonOutYield()
    {
        yield return "";
        yield return "";
    }

    static void Apply<T>(Action<T> a, T x)
    {
        a(x);
    }

    static T ApplyFunc<S, T>(Func<S, T> f, S x)
    {
        return f(x);
    }

    public delegate void MyDelegate(string x);

    static MyDelegate myDelegate;

    static void ApplyDelegate(MyDelegate a, string x)
    {
        a(x);
    }

    static string TaintedParam(string tainted)
    {
        var sink11 = tainted;
        Check(sink11);
        return sink11;
    }

    static string NonTaintedParam(string nonTainted)
    {
        var nonSink0 = nonTainted;
        Check(nonSink0);
        return nonSink0;
    }

    class Test
    {
        public static string SinkField0;
        public static string SinkProperty0 { get; set; }
        public static string NonSinkField0;
        public static string NonSinkProperty0 { get; set; }
        public static string NonSinkProperty1 { get { return ""; } set { } }
    }

    string InProperty
    {
        get { return ""; }
        set { var sink20 = value; Check(sink20); }
    }

    string NonInProperty
    {
        get { return ""; }
        set { var nonSink0 = value; Check(nonSink0); }
    }

    string OutProperty
    {
        get { return "taint source"; }
    }

    string NonOutProperty
    {
        get { return ""; }
    }

    static void AppendToStringBuilder(StringBuilder sb, string s)
    {
        sb.Append(s);
    }

    void TestStringBuilderFlow()
    {
        var sb = new StringBuilder();
        AppendToStringBuilder(sb, "taint source");
        var sink43 = sb.ToString();
        Check(sink43);

        sb.Clear();
        var nonSink = sb.ToString();
        Check(nonSink);
    }

    void TestStringFlow()
    {
        var sink44 = string.Join(",", "whatever", "taint source");
        Check(sink44);

        var nonSink = string.Join(",", "whatever", "not tainted");
        Check(nonSink);
    }

    public void M4()
    {
        var task = Task.Run(() => "taint source");
        var awaitable = task.ConfigureAwait(false);
        var awaiter = awaitable.GetAwaiter();
        var sink45 = awaiter.GetResult();
        Check(sink45);
    }
}

static class IEnumerableExtensions
{
    public static IEnumerable<S> SelectEven<S, T>(this IEnumerable<T> e, Func<T, S> f)
    {
        int i = 0;
        foreach (var x in e)
        {
            if (i++ % 2 == 0) yield return f(x);
        }
    }
}

// semmle-extractor-options: /r:System.Diagnostics.Process.dll /r:System.Linq.dll /r:System.Linq.Expressions.dll /r:System.Linq.Queryable.dll /r:System.ComponentModel.Primitives.dll
