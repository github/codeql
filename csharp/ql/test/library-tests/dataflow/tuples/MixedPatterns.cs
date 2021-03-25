using System;
public class C
{
    public void M()
    {
        Base a = new Item() { X = "taint source" };
        var ret1 = a switch
        {
            Item("taint source", 1) { Y: 10 } z => Sink(z.X),       // [TRUE POSITIVE]
            Item("not taint source", 1) { Y: 10 } z => Sink(z.X),   // [FALSE POSITIVE]
            // these work because Base implements ITuple:
            (0, 0) => "",
            (var s, 0) => Sink(s),                                  // [FALSE NEGATIVE]
        };

        Item b = new Item() { X = "taint source" };
        var ret2 = b switch
        {
            ("taint source", 0) => Sink(b.X),       // [TRUE POSITIVE]
            ("not taint source", 0) => Sink(b.X),   // [FALSE POSITIVE]
            ("taint source", 3) p => Sink(p.X),     // [TRUE POSITIVE]
            ("not taint source", 3) p => Sink(p.X), // [FALSE POSITIVE]
            (var j, 5) p => Sink(j),                // [FALSE NEGATIVE]
            // ValueTuple<int,int> (3,3) t => "3" + t.Item1, // Doesn't work
        };

        object o = new Item() { X = "taint source" };
        var ret3 = o switch
        {
            Item("taint source", 1) { Y: 10 } z => Sink(z.X),       // [TRUE POSITIVE]
            Item("not taint source", 1) { Y: 10 } z => Sink(z.X),   // [FALSE POSITIVE]
            Item(var i, var j) { Y: 10 } z => Sink(i),              // [FALSE NEGATIVE]
            (0, 0) => "0",
            (var s, 1) => Sink(s),                                  // [FALSE NEGATIVE]
            ValueTuple<int, int>(var i, 3) { Item2: 3 } t1 => Sink(i),          // not tainted, wrong data type
            ValueTuple<string, int>("taint source", 3) { Item2: 3 } t1 => Sink(o),      // [FALSE NEGATIVE]
            ValueTuple<string, int>("not taint source", 3) { Item2: 3 } t1 => Sink(o),  // [FALSE NEGATIVE]
            ValueTuple<string, int>(var i, 3) { Item2: 3 } t1 => Sink(i),               // [FALSE NEGATIVE]
        };

        var tup = ("taint source", 2);
        var ret4 = tup switch
        {
            ("taint source", 2) => Sink(tup.Item1),             // [TRUE POSITIVE]
            ("not taint source", 2) => Sink(tup.Item1),         // [FALSE POSITIVE]
            ValueTuple<string, int>("taint source", 3) { Item2: 3 } t1 => Sink(tup.Item1),      // [TRUE POSITIVE]
            ValueTuple<string, int>("not taint source", 3) { Item2: 3 } t1 => Sink(tup.Item1),  // [FALSE POSITIVE]
            ValueTuple<string, int>(var i, 3) { Item2: 3 } t1 => Sink(i),   // [FALSE NEGATIVE]
            (var i, 5) => Sink(i),                                          // [FALSE NEGATIVE]
        };
    }

    public string Sink(Object o) => throw null;
}

class Base : System.Runtime.CompilerServices.ITuple
{
    public int Length => throw null;
    public object this[int c] => throw null;
}

class Item : Base
{
    public string X { get; set; }
    public int Y { get; set; }

    public void Deconstruct(out string x, out int y)
    {
        x = X;
        y = Y;
    }
}