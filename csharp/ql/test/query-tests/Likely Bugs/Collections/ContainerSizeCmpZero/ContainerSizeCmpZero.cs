using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System;

class MyList<T> : List<T> { }

class MyList2<T> : ICollection<T>
{
    public int Count { get { return 0; } }
    public bool IsReadOnly { get { return true; } }

    public void Add(T item) { }
    public void Clear() { }
    public bool Contains(T item) { return false; }
    public void CopyTo(T[] a, int x) { }
    public IEnumerator<T> GetEnumerator() { throw new System.Exception(); }
    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() { throw new System.Exception(); }
    public bool Remove(T item) { return false; }
}

class Test
{
    static void Main(string[] args)
    {
        bool b;

        /////////
        // Arrays

        // NOT OK: always true
        b = args.Length >= 0;

        // NOT OK: always true
        b = 0 <= args.Length;

        // NOT OK: always false
        b = args.Length < 0;

        // NOT OK: always false
        b = 0 > args.Length;

        // OK: sometimes could be false
        b = args.Length > 0;

        // OK: sometimes could be false
        b = 0 < args.Length;

        // OK: sometimes could be true
        b = args.Length <= 0;

        // OK: sometimes could be true
        b = 0 >= args.Length;

        /////////
        // Containers
        var xs = new MyList2<int>();
        var ys = new Stack<string>();

        // NOT OK
        b = xs.Count >= 0;
        b = 0 <= xs.Count;
        b = 0 <= ys.Count;

        b = xs.Count < 0;
        b = 0 > ys.Count;

        // OK
        b = xs.Count >= -1;

        // OK
        b = 0 < xs.Count;

        /////////
        // missed in java, but not here

        b = xs.Count >= (short)0;
        b = xs.Count >= (byte)0;

        /////////
        // missed cases

        // NOT OK
        b = xs.Count >= 0 + 0;
        b = xs.Count >= 0 - 0;

        b = args.LongLength >= 0L;

        /////////
        // Nested Containers
        var zs = new MyList<List<string>>();

        // NOT OK
        b = zs.Count >= 0;
        b = zs.Count < 0;

        // NOT OK
        b = zs[0].Count >= 0;

        // NOT OK
        b = zs[0][0].Length >= 0;

        /////////
        // Dictionaries
        var ws = new Dictionary<int, string>();

        // NOT OK: Always true
        b = ws.Count >= 0;

        // NOT OK: Always true
        b = 0 <= ws.Count;

        // OK: can be false
        b = ws.Count >= -1;

        // OK: can be false
        b = 0 < ws.Count;

        /////////
        // Non-generic containers/dictionaries

        var us = new System.Collections.Hashtable();
        var vs = new System.Collections.BitArray(1);

        // NOT OK: Always true
        b = us.Count >= 0;
        b = 0 > vs.Count;

        // NOT OK: Always true
        b = 0 <= us.Count;
        b = vs.Count < 0;

        // OK: can be false
        b = us.Count >= -1;
        b = vs.Count >= -1;

        // OK: can be false
        b = 0 < us.Count;
        b = 0 < vs.Count;
    }

    static bool ReadOnlyCollection(IReadOnlyCollection<int> xs, IReadOnlyList<string> ys)
    {
        bool b;

        // NOT OK
        b = xs.Count >= 0;
        b = 0 <= xs.Count;
        b = 0 <= ys.Count;

        b = xs.Count < 0;
        b = ys.Count < 0;
        b = 0 > xs.Count;

        return b;
    }

    static bool DebugAssert(ICollection<int> c)
    {
        Debug.Assert(c.Count >= 0);  // OK
        return c.Count >= 0;  // NOT OK
    }
}
