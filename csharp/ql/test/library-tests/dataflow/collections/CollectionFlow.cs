using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class CollectionFlow
{
    public class A { }

    public A[] As;

    public static void Sink<T>(T t) { }

    public static void SinkElem<T>(T[] ts) => Sink(ts[0]);

    public static void SinkLastElem<T>(T[] ts) => Sink(ts[^1]);

    public static void SinkListElem<T>(IList<T> list) => Sink(list[0]);

    public static void SinkDictValue<T>(IDictionary<int, T> dict) => Sink(dict[0]);

    public static void SinkDictKey<T>(IDictionary<T, int> dict) => Sink(dict.Keys.First());

    public static T First<T>(T[] ts) => ts[0];

    public static T Last<T>(T[] ts) => ts[^1];

    public static T ListFirst<T>(IList<T> list) => list[0];

    public static T DictIndexZero<T>(IDictionary<int, T> dict) => dict[0];

    public static T DictFirstValue<T>(IDictionary<int, T> dict) => dict.First().Value;

    public static T DictValuesFirst<T>(IDictionary<int, T> dict) => dict.Values.First();

    public static T DictKeysFirst<T>(IDictionary<T, int> dict) => dict.Keys.First();

    public static T DictFirstKey<T>(IDictionary<T, int> dict) => dict.First().Key;

    public static void SinkParams<T>(params T[] args) => Sink(args[0]);

    public static void SinkCollectionParams<T>(params IEnumerable<T> args) => Sink(args.First());

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

    public void ArrayInitializerCSharp6Flow()
    {
        var a = new A();
        var c = new CollectionFlow() { As = { [0] = a } };
        Sink(c.As[0]); // flow
        SinkElem(c.As); // flow
        Sink(First(c.As)); // flow
    }

    public void ArrayInitializerCSharp6NoFlow(A other)
    {
        var a = new A();
        var c = new CollectionFlow() { As = { [0] = other } };
        Sink(c.As[0]); // no flow
        SinkElem(c.As); // no flow
        Sink(First(c.As)); // no flow
    }

    public void ArrayInitializerImplicitIndexFlow()
    {
        var a = new A();
        var c = new CollectionFlow() { As = { [^1] = a } };
        Sink(c.As[^1]); // flow
        SinkLastElem(c.As); // flow
        Sink(Last(c.As)); // flow
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

    public void ArrayAssignmentImplicitIndexFlow()
    {
        var a = new A();
        var @as = new A[1];
        @as[^1] = a;
        Sink(@as[^1]); // flow
        SinkLastElem(@as); // flow
        Sink(Last(@as)); // flow
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
        Sink(DictFirstValue(dict)); // flow
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
        Sink(DictFirstValue(dict)); // flow
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

    public void DictionaryValueInitializerCSharp6Flow()
    {
        var a = new A();
        var dict = new Dictionary<int, A>() { [0] = a };
        Sink(dict[0]); // flow
        SinkDictValue(dict); // flow
        Sink(DictIndexZero(dict)); // flow
        Sink(DictFirstValue(dict)); // flow
        Sink(DictValuesFirst(dict)); // flow
    }

    public void DictionaryValueInitializerCSharp6NoFlow(A other)
    {
        var a = new A();
        var dict = new Dictionary<int, A>() { [0] = other };
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
        Sink(dict.Keys.First()); // flow
        SinkDictKey(dict); // flow
        Sink(DictKeysFirst(dict)); // flow
        Sink(DictFirstKey(dict)); // flow
    }

    public void DictionaryKeyInitializerNoFlow(A other)
    {
        var dict = new Dictionary<A, int>() { { other, 0 } };
        Sink(dict.Keys.First()); // no flow
        SinkDictKey(dict); // no flow
        Sink(DictKeysFirst(dict)); // no flow
        Sink(DictFirstKey(dict)); // no flow
    }

    public void DictionaryKeyInitializerCSharp6Flow()
    {
        var a = new A();
        var dict = new Dictionary<A, int>() { [a] = 0 };
        Sink(dict.Keys.First()); // flow
        SinkDictKey(dict); // flow
        Sink(DictKeysFirst(dict)); // flow
        Sink(DictFirstKey(dict)); // flow
    }

    public void DictionaryKeyInitializerCSharp6NoFlow(A other)
    {
        var dict = new Dictionary<A, int>() { [other] = 0 };
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
            Sink(enumerator.Current); // flow
    }

    public void ListGetEnumeratorNoFlow(A other)
    {
        var list = new List<A>();
        list.Add(other);
        var enumerator = list.GetEnumerator();
        while (enumerator.MoveNext())
            Sink(enumerator.Current); // no flow
    }

    public void SelectFlow()
    {
        var a = new A();
        var list = new List<KeyValuePair<A, int>>();
        list.Add(new KeyValuePair<A, int>(a, 0));
        list.Select(kvp =>
        {
            Sink(kvp.Key); // flow
            return kvp.Value;
        });
    }

    public void SelectNoFlow()
    {
        var a = new A();
        var list = new List<KeyValuePair<A, int>>();
        list.Add(new KeyValuePair<A, int>(a, 0));
        list.Select(kvp =>
        {
            Sink(kvp.Value); // no flow
            return kvp.Value;
        });
    }

    void SetArray(A[] array, A element) => array[0] = element;

    public void ArraySetterFlow()
    {
        var a = new A();
        var @as = new A[1];
        SetArray(@as, a);
        Sink(@as[0]); // flow
        SinkElem(@as); // flow
        Sink(First(@as)); // flow
    }

    public void ArraySetterNoFlow(A other)
    {
        var a = new A();
        var @as = new A[1];
        SetArray(@as, other);
        Sink(@as[0]); // no flow
        SinkElem(@as); // no flow
        Sink(First(@as)); // no flow
    }

    void SetList(List<A> list, A element) => list.Add(element);

    public void ListSetterFlow()
    {
        var a = new A();
        var list = new List<A>();
        SetList(list, a);
        Sink(list[0]); // flow
        SinkListElem(list); // flow
        Sink(ListFirst(list)); // flow
    }

    public void ListSetterNoFlow(A other)
    {
        var list = new List<A>();
        SetList(list, other);
        Sink(list[0]); // no flow
        SinkListElem(list); // no flow
        Sink(ListFirst(list)); // no flow
    }

    public void ParamsFlow()
    {
        SinkParams(new A()); // flow
        SinkParams(null, new A()); // flow
        SinkParams(null, new A(), null); // flow
        SinkParams(new A[] { new A() }); // flow
    }

    public void ParamsNoFlow(A other)
    {
        SinkParams(other); // no flow
        SinkParams(null, other); // no flow
        SinkParams(null, other, null); // no flow
        SinkParams(new A[] { other }); // no flow
    }

    public void ParamsCollectionFlow()
    {
        SinkCollectionParams(new A()); // flow
        SinkCollectionParams(null, new A()); // flow
        SinkCollectionParams(null, new A(), null); // flow
        SinkCollectionParams([new A()]); // flow
    }

    public void ListAddClearNoFlow()
    {
        var a = new A();
        var list = new List<A>();
        list.Add(a);
        list.Clear();
        Sink(list[0]); // no flow
        SinkListElem(list); // no flow
        Sink(ListFirst(list)); // no flow
    }

    [System.Runtime.CompilerServices.InlineArray(10)]
    struct MyInlineArray
    {
        private A myInlineArrayElements;
    }

    public void InlineArraySetterFlow()
    {
        var a = new A();
        var array = new MyInlineArray();
        array[0] = a;
        Sink(array[0]); // flow
    }

    public void InlineArraySetterNoFlow(A other)
    {
        var array = new MyInlineArray();
        array[0] = other;
        Sink(array[0]); // no flow
    }

    public void CollectionExpressionNoFlow(A a)
    {
        A[] array = [a];
        Sink(array[0]); // no flow
    }

    public void CollectionExpressionElementFlow()
    {
        var a = new A();
        A[] array = [a];
        Sink(array[0]); // flow
    }

    public void CollectionExpressionElementFlowList()
    {
        var a = new A();
        List<A> l = [a];
        Sink(l[0]); // flow
    }

    public void CollectionExpressionSpreadElementNoFlow(A[] other)
    {
        A[] array = [.. other];
        Sink(array[0]); // no flow
    }

    public void CollectionExpressionSpreadElementFlow()
    {
        var a = new A();
        A[] temp = [a];
        A[] array = [.. temp];
        Sink(array[0]); // flow
    }

    [System.Runtime.CompilerServices.CollectionBuilder(typeof(IntegerCollectionBuilder), "Create")]
    public class IntegerCollection : IEnumerable<int>
    {
        private int[] items;

        public A? Payload { get; set; }

        public IntegerCollection(ReadOnlySpan<int> items)
        {
            this.items = items.ToArray();
            Payload = null;
        }

        public IEnumerator<int> GetEnumerator() => items.AsEnumerable<int>().GetEnumerator();

        IEnumerator IEnumerable.GetEnumerator() => items.GetEnumerator();
    }

    public static class IntegerCollectionBuilder
    {
        public static IntegerCollection Create(ReadOnlySpan<int> elements)
            => new IntegerCollection(elements);
    }

    public void CollectionExpressionSpreadElementNoFieldFlow()
    {
        IntegerCollection ic0 = [0];
        ic0.Payload = new A();
        IntegerCollection ic1 = [.. ic0];
        Sink(ic1.Payload); // No flow
    }

    public void SpanConstructorFlow()
    {
        var a = new A();
        Span<A> span = new Span<A>(ref a);
        Sink(span[0]); // flow
    }

    public void SpanToArrayFlow()
    {
        var a = new A();
        Span<A> span = new Span<A>(ref a);
        var arr = span.ToArray();
        Sink(arr[0]); // flow
    }

    public void SpanFillFlow(Span<A> target)
    {
        var a = new A();
        target.Fill(a);
        Sink(target[0]); // flow
    }

    public void SpanCopyToFlow(Span<A> target)
    {
        var source = new Span<A>(new[] { new A() });
        source.CopyTo(target);
        Sink(target[0]); // flow
    }

    public void ReadOnlySpanConstructorFlow()
    {
        var a = new A();
        ReadOnlySpan<A> span = new ReadOnlySpan<A>(new[] { a });
        Sink(span[0]); // flow
    }
}
