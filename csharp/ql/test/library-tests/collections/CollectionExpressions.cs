using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;

public class MyClass
{
    public void M1()
    {
        var y = 4;
        int[] x1 = [1 + 4, 2, 8];
        Span<int> x2 = [3, y];
        int[] all = [.. x1, .. x2];
        int[][] jagged = [[1, y], x1];
        int[] nested = [1, .. (int[])[.. x1]];
        IntegerCollection collection = [4, y, 9, .. x1];
        M2([1, 2, 3]);
    }

    public static void M2(Span<int> x) { }

    public static void M2(ReadOnlySpan<int> x) { }
}

[System.Runtime.CompilerServices.CollectionBuilder(typeof(IntegerCollectionBuilder), "Create")]
public class IntegerCollection : IEnumerable<int>
{
    private int[] items;

    public IntegerCollection(ReadOnlySpan<int> items)
    {
        this.items = items.ToArray();
    }

    public IEnumerator<int> GetEnumerator() => items.AsEnumerable<int>().GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator() => items.GetEnumerator();
}

public static class IntegerCollectionBuilder
{
    public static IntegerCollection Create(ReadOnlySpan<int> elements)
        => new IntegerCollection(elements);
}

