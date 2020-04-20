// semmle-extractor-options: /r:System.Linq.dll
using System;
using System.Collections.Generic;
using System.Linq;

public class CollectionFlow
{
    public class A { }

    public void ArrayInitializerFlow()
    {
        var a = new A();
        var @as = new[] { a };
        Sink(@as[0]); // flow
        SinkElem(@as); // flow
        Sink(First(@as)); // flow
    }

    public void ArrayInitializerNoFlow(A other)
    {
        var a = new A();
        var @as = new[] { other };
        Sink(@as[0]); // no flow
        SinkElem(@as); // no flow
        Sink(First(@as)); // no flow
    }

    public void ArrayAssignmentFlow()
    {
        var a = new A();
        var @as = new A[1];
        @as[0] = a;
        Sink(@as[0]); // flow
        SinkElem(@as); // flow
        Sink(First(@as)); // flow
    }

    public void ArrayAssignmentNoFlow(A other)
    {
        var a = new A();
        var @as = new A[1];
        @as[0] = other;
        Sink(@as[0]); // no flow
        SinkElem(@as); // no flow
        Sink(First(@as)); // no flow
    }

    public void ListAssignmentFlow()
    {
        var a = new A();
        var list = new List<A>();
        list[0] = a;
        Sink(list[0]); // flow
        SinkListElem(list); // flow
        Sink(ListFirst(list)); // flow
    }

    public void ListAssignmentNoFlow(A other)
    {
        var list = new List<A>();
        list[0] = other;
        Sink(list[0]); // no flow
        SinkListElem(list); // no flow
        Sink(ListFirst(list)); // no flow
    }

    public void ListInitializerFlow()
    {
        var a = new A();
        var list = new List<A>() { a };
        Sink(list[0]); // flow
        SinkListElem(list); // flow
        Sink(ListFirst(list)); // flow
    }

    public void ListInitializerNoFlow(A other)
    {
        var list = new List<A>() { other };
        Sink(list[0]); // no flow
        SinkListElem(list); // no flow
        Sink(ListFirst(list)); // no flow
    }

    public void ListAddFlow()
    {
        var a = new A();
        var list = new List<A>();
        list.Add(a);
        Sink(list[0]); // flow
        SinkListElem(list); // flow
        Sink(ListFirst(list)); // flow
    }

    public void ListAddNoFlow(A other)
    {
        var list = new List<A>();
        list.Add(other);
        Sink(list[0]); // no flow
        SinkListElem(list); // no flow
        Sink(ListFirst(list)); // no flow
    }

    public void DictionaryAssignmentFlow()
    {
        var a = new A();
        var dict = new Dictionary<int, A>();
        dict[0] = a;
        Sink(dict[0]); // flow
        SinkDictValue(dict); // flow
        Sink(DictIndexZero(dict)); // flow
        Sink(DictFirstValue(dict)); // flow [MISSING]
        Sink(DictValuesFirst(dict)); // flow
    }

    public void DictionaryAssignmentNoFlow(A other)
    {
        var dict = new Dictionary<int, A>();
        dict[0] = other;
        Sink(dict[0]); // no flow
        SinkDictValue(dict); // no flow
        Sink(DictIndexZero(dict)); // no flow
        Sink(DictFirstValue(dict)); // no flow
        Sink(DictValuesFirst(dict)); // no flow
    }

    public void DictionaryValueInitializerFlow()
    {
        var a = new A();
        var dict = new Dictionary<int, A>() { { 0, a } };
        Sink(dict[0]); // flow
        SinkDictValue(dict); // flow
        Sink(DictIndexZero(dict)); // flow
        Sink(DictFirstValue(dict)); // flow [MISSING]
        Sink(DictValuesFirst(dict)); // flow
    }

    public void DictionaryValueInitializerNoFlow(A other)
    {
        var dict = new Dictionary<int, A>() { { 0, other } };
        Sink(dict[0]); // no flow
        SinkDictValue(dict); // no flow
        Sink(DictIndexZero(dict)); // no flow
        Sink(DictFirstValue(dict)); // no flow
        Sink(DictValuesFirst(dict)); // no flow
    }

    public void DictionaryKeyInitializerFlow()
    {
        var a = new A();
        var dict = new Dictionary<A, int>() { { a, 0 } };
        Sink(dict.Keys.First()); // flow [MISSING]
        SinkDictKey(dict); // flow [MISSING]
        Sink(DictKeysFirst(dict)); // flow [MISSING]
        Sink(DictFirstKey(dict)); // flow [MISSING]
    }

    public void DictionaryKeyInitializerNoFlow(A other)
    {
        var dict = new Dictionary<A, int>() { { other, 0 } };
        Sink(dict.Keys.First()); // no flow
        SinkDictKey(dict); // no flow
        Sink(DictKeysFirst(dict)); // no flow
        Sink(DictFirstKey(dict)); // no flow
    }

    public void ForeachFlow()
    {
        var a = new A();
        var @as = new[] { a };
        foreach (var x in @as)
            Sink(x); // flow
    }

    public void ForeachNoFlow(A other)
    {
        var @as = new[] { other };
        foreach (var x in @as)
            Sink(x); // no flow
    }

    public void ArrayGetEnumeratorFlow()
    {
        var a = new A();
        var @as = new[] { a };
        var enumerator = @as.GetEnumerator();
        while (enumerator.MoveNext())
            Sink(enumerator.Current); // flow
    }

    public void ArrayGetEnumeratorNoFlow(A other)
    {
        var @as = new[] { other };
        var enumerator = @as.GetEnumerator();
        while (enumerator.MoveNext())
            Sink(enumerator.Current); // no flow
    }

    public void ListGetEnumeratorFlow()
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

    public static T DictIndexZero<T>(IDictionary<int, T> dict) => dict[0];

    public static T DictFirstValue<T>(IDictionary<int, T> dict) => dict.First().Value;

    public static T DictValuesFirst<T>(IDictionary<int, T> dict) => dict.Values.First();

    public static T DictKeysFirst<T>(IDictionary<T, int> dict) => dict.Keys.First();

    public static T DictFirstKey<T>(IDictionary<T, int> dict) => dict.First().Key;
}
