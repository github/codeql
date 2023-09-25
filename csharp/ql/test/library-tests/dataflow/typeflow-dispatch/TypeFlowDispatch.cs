using System;
using System.Collections.Generic;
using System.Linq;

public class A
{
    static T Source<T>(T source) => throw null;

    public static void Sink<T>(T t) { }

    static void Apply1<T>(Action<T> f, T x)
    {
        f(x);
    }

    static void ApplyWrap1<T>(Action<T> f, T x)
    {
        Apply1(f, x);
    }

    void TestLambdaDispatch1()
    {
        ApplyWrap1(x => { Sink(x); }, Source("A")); // $ hasValueFlow=A
        ApplyWrap1(x => { Sink(x); }, "B"); // no flow
        ApplyWrap1(x => { }, Source("C"));
        ApplyWrap1(x => { }, "D");
    }

    void ListForEachWrap<T>(List<T> l, Action<T> f)
    {
        l.ForEach(f);
    }

    void TestLambdaDispatch2()
    {
        var tainted = new List<string> { Source("E") };
        var safe = new List<string>();
        ListForEachWrap(safe, x => { Sink(x); }); // no flow
        ListForEachWrap(tainted, x => { Sink(x); }); // $ hasValueFlow=E
    }

    static void Apply2<T>(Action<T> f, T x)
    {
        f(x);
    }

    static void ApplyWrap2<T>(Action<T> f, T x)
    {
        Apply2(f, x);
    }

    void SinkMethodGroup1<T>(T t) => Sink(t); // $ hasValueFlow=F $ hasValueFlow=G
    void SinkMethodGroup2<T>(T t) => Sink(t);

    void TestLambdaDispatch3()
    {
        ApplyWrap2(SinkMethodGroup1, Source("F"));
        ApplyWrap2(SinkMethodGroup2, "B");
    }

    void ForEach<T>(List<T> l, Action<T> f)
    {
        foreach (var x in l)
            f(x);
    }

    void ForEachWrap<T>(List<T> l, Action<T> f)
    {
        ForEach(l, f);
    }

    void TestLambdaDispatch4()
    {
        var tainted = new List<string> { Source("G") };
        var safe = new List<string>();
        ForEachWrap(safe, SinkMethodGroup2);
        ForEachWrap(tainted, SinkMethodGroup1);
    }

    class TaintedClass
    {
        public override string ToString() => Source("TaintedClass");
    }

    class SafeClass
    {
        public override string ToString() => "safe";
    }

    string ConvertToString(object o) => o.ToString();

    string ConvertToStringWrap(object o) => ConvertToString(o);

    void TestToString1()
    {
        var unused = ConvertToStringWrap(new TaintedClass());
        Sink(ConvertToStringWrap(new SafeClass())); // no flow
    }
}
