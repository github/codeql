using System;
using System.Collections.Generic;
using System.Linq;

class DefiningAccesses
{
    static int Source(int id) => id;
    static void Sink<T>(T value) { }
    static void Out(out int value) { value = Source(1); }
    static (int, int) Pair() => (Source(11), Source(12));

    static unsafe void Fixed(string text)
    {
        fixed (char* chars = text)
            Sink(*chars);
    }

    static void Test(IEnumerable<int> values, object input)
    {
        int uninitialized;
        uninitialized = Source(2);
        Sink(uninitialized); // $ hasValueFlow=2
        int multiA, multiB;
        const int constant = 42;
        for (int index = 0; index < constant; index++)
            Sink(index);
        int initialized = Source(3);
        Sink(initialized); // $ hasValueFlow=3
        Out(out int output);
        Sink(output); // $ hasValueFlow=1
        Out(out _);
        (int first, (int second, int third)) = (Source(4), (Source(5), Source(6)));
        Sink(first); // $ hasValueFlow=4
        Sink(second); // $ hasValueFlow=5
        Sink(third); // $ hasValueFlow=6
        var (fourth, fifth) = (Source(7), Source(8));
        Sink(fourth); // $ hasValueFlow=7
        Sink(fifth); // $ hasValueFlow=8
        var (sixth, seventh) = Pair();
        Sink(sixth); // $ hasValueFlow=11
        Sink(seventh); // $ hasValueFlow=12
        foreach (var item in values)
            Sink(item);
        foreach (var element in new[] { Source(13) })
            Sink(element); // $ hasValueFlow=13
        foreach (var (left, right) in new[] { (Source(9), Source(10)) })
        {
            Sink(left); // $ MISSING: hasValueFlow=9
            Sink(right); // $ MISSING: hasValueFlow=10
        }
        try { throw new Exception(); }
        catch (Exception exception) when (exception.Message != null) { Sink(exception); }
        if (input is int pattern)
            Sink(pattern);
        using var stream = new System.IO.MemoryStream();
        Sink(stream);
        var query = from value in values let next = value + 1 select next;
        Sink(query);
    }
}
