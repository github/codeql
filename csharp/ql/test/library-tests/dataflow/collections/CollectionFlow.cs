// semmle-extractor-options: /r:System.Linq.dll
using System;
using System.Collections.Generic;
using System.Linq;

public class A
{
    public void M1()
    {
        var a = new A();
        var @as = new[] { a };
        Sink(@as[0]); // flow
        SinkElem(@as); // flow
        Sink(First(@as)); // flow
    }

    public void M2(A other)
    {
        var a = new A();
        var @as = new[] { other };
        Sink(@as[0]); // no flow
        SinkElem(@as); // no flow
        Sink(First(@as)); // no flow
    }

    public void M3()
    {
        var a = new A();
        var @as = new A[1];
        @as[0] = a;
        Sink(@as[0]); // flow
        SinkElem(@as); // flow
        Sink(First(@as)); // flow
    }

    public void M4(A other)
    {
        var a = new A();
        var @as = new A[1];
        @as[0] = other;
        Sink(@as[0]); // no flow
        SinkElem(@as); // no flow
        Sink(First(@as)); // no flow
    }

    public void M5()
    {
        var a = new A();
        var list = new List<A>();
        list[0] = a;
        Sink(list[0]); // flow
        SinkListElem(list); // flow
        Sink(ListFirst(list)); // flow
    }

    public void M6(A other)
    {
        var list = new List<A>();
        list[0] = other;
        Sink(list[0]); // no flow
        SinkListElem(list); // no flow
        Sink(ListFirst(list)); // no flow
    }

    public void M7()
    {
        var a = new A();
        var list = new List<A>() { a };
        Sink(list[0]); // flow
        SinkListElem(list); // flow
        Sink(ListFirst(list)); // flow
    }

    public void M8(A other)
    {
        var list = new List<A>() { other };
        Sink(list[0]); // no flow
        SinkListElem(list); // no flow
        Sink(ListFirst(list)); // no flow
    }

    public void M9()
    {
        var a = new A();
        var list = new List<A>();
        list.Add(a);
        Sink(list[0]); // flow
        SinkListElem(list); // flow
        Sink(ListFirst(list)); // flow
    }

    public void M10(A other)
    {
        var list = new List<A>();
        list.Add(other);
        Sink(list[0]); // no flow
        SinkListElem(list); // no flow
        Sink(ListFirst(list)); // no flow
    }

    public void M11()
    {
        var a = new A();
        var dict = new Dictionary<int, A>();
        dict[0] = a;
        Sink(dict[0]); // flow
        SinkDictValue(dict); // flow
        Sink(DictFirstValueA(dict)); // flow
        Sink(DictFirstValueB(dict)); // flow [MISSING]
        Sink(DictFirstValueC(dict)); // flow
    }

    public void M12(A other)
    {
        var dict = new Dictionary<int, A>();
        dict[0] = other;
        Sink(dict[0]); // no flow
        SinkDictValue(dict); // no flow
        Sink(DictFirstValueA(dict)); // no flow
        Sink(DictFirstValueB(dict)); // no flow
        Sink(DictFirstValueC(dict)); // no flow
    }

    public void M13()
    {
        var a = new A();
        var dict = new Dictionary<int, A>() { { 0, a } };
        Sink(dict[0]); // flow
        SinkDictValue(dict); // flow
        Sink(DictFirstValueA(dict)); // flow
        Sink(DictFirstValueB(dict)); // flow [MISSING]
        Sink(DictFirstValueC(dict)); // flow
    }

    public void M14(A other)
    {
        var dict = new Dictionary<int, A>() { { 0, other } };
        Sink(dict[0]); // no flow
        SinkDictValue(dict); // no flow
        Sink(DictFirstValueA(dict)); // no flow
        Sink(DictFirstValueB(dict)); // no flow
        Sink(DictFirstValueC(dict)); // no flow
    }

    public void M15()
    {
        var a = new A();
        var dict = new Dictionary<A, int>() { { a, 0 } };
        Sink(dict.Keys.First()); // flow [MISSING]
        SinkDictKey(dict); // flow [MISSING]
        Sink(DictFirstKeyA(dict)); // flow [MISSING]
        Sink(DictFirstKeyB(dict)); // flow [MISSING]
    }

    public void M16(A other)
    {
        var dict = new Dictionary<A, int>() { { other, 0 } };
        Sink(dict.Keys.First()); // no flow
        SinkDictKey(dict); // no flow
        Sink(DictFirstKeyA(dict)); // no flow
        Sink(DictFirstKeyB(dict)); // no flow
    }

    public void M17()
    {
        var a = new A();
        var @as = new[] { a };
        foreach (var x in @as)
            Sink(x); // flow
    }

    public void M18(A other)
    {
        var @as = new[] { other };
        foreach (var x in @as)
            Sink(x); // no flow
    }

    public void M19()
    {
        var a = new A();
        var @as = new[] { a };
        var enumerator = @as.GetEnumerator();
        while (enumerator.MoveNext())
            Sink(enumerator.Current); // flow
    }

    public void M20(A other)
    {
        var @as = new[] { other };
        var enumerator = @as.GetEnumerator();
        while (enumerator.MoveNext())
            Sink(enumerator.Current); // no flow
    }

    public void M21()
    {
        var a = new A();
        var list = new List<A>();
        list.Add(a);
        var enumerator = list.GetEnumerator();
        while (enumerator.MoveNext())
            Sink(enumerator.Current); // flow [MISSING]
    }

    public static void Sink<T>(T t) { }

    public static void SinkElem<T>(T[] ts) => Sink(ts[0]);

    public static void SinkListElem<T>(IList<T> list) => Sink(list[0]);

    public static void SinkDictValue<T>(IDictionary<int, T> dict) => Sink(dict[0]);

    public static void SinkDictKey<T>(IDictionary<T, int> dict) => Sink(dict.Keys.First());

    public static T First<T>(T[] ts) => ts[0];

    public static T ListFirst<T>(IList<T> list) => list[0];

    public static T DictFirstValueA<T>(IDictionary<int, T> dict) => dict[0];

    public static T DictFirstValueB<T>(IDictionary<int, T> dict) => dict.First().Value;

    public static T DictFirstValueC<T>(IDictionary<int, T> dict) => dict.Values.First();

    public static T DictFirstKeyA<T>(IDictionary<T, int> dict) => dict.Keys.First();

    public static T DictFirstKeyB<T>(IDictionary<T, int> dict) => dict.First().Key;
}
