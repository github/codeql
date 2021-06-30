using System;
using System.Collections;
using System.Collections.Generic;

public class ContainerTest
{
    // Test 1: Variable scopes

    // Test 1a: Private field
    private IList<int> c1a = new List<int> { 1, 2 }; // BAD: private

    // Test 1b: protected field
    protected IList<int> c1b = new List<int> { 1, 2 }; // GOOD: protected

    // Test 1c: public field
    public IList<int> c1c = new List<int> { 1, 2 }; // GOOD: public

    // Test 1d: internal field
    internal IList<int> c1d = new List<int> { 1, 2 }; // BAD: internal

    void TestScopes()
    {
        c1a.Add(1);
        c1b.Add(2);
        c1c.Add(3);
        c1d.Add(4);

        // Test 1e: Local variable
        IList<int> c1e = new List<int> { 1, 2 }; // BAD: local
        c1e.Add(5);
    }

    // Test 2: Method names

    void TestMethodNames()
    {
        // Test 2a: Writeonly method names
        IList<int> c2a = new List<int> { 1, 2 }; // BAD: writeonly methods
        c2a.Add(1);
        c2a.Clear();
        c2a.Insert(1, 2);
        c2a.Remove(1);
        c2a.RemoveAt(3);

        // Test 2b: Read/write method names
        IList<int> c2b = new List<int> { 1, 2 }; // GOOD: read method
        bool b = c2b.Contains(1);

        // Test 2c: Other method names
        var c2c = new Stack(); // BAD
        c2c.Push(1);

        var c2d = new BitArray(10); // BAD
        c2d.Set(1, true);
        c2d.SetAll(false);

        var c2j = new LinkedList<int>(); // BAD
        c2j.AddFirst(1);
        c2j.AddLast(2);
        c2j.RemoveFirst();
        c2j.RemoveLast();
    }

    // Test 3: Variable uses

    IList<int> f() { return new List<int>(); }

    void f(IList<int> x) { }

    IList<int> g()
    {
        // Returned from function
        var c3c = new List<int> { 2, 3, 4 }; // GOOD: returned
        c3c.Add(5);
        return c3c;
    }

    IList<int> h
    {
        get
        {
            // Returned from property
            var c3d = new List<int>(); // GOOD: returned
            c3d.Add(1);
            return c3d;
        }
    }

    IList<int> this[int i]
    {
        get
        {
            // Returned from property
            var c3e = new List<int>(); // GOOD: returned
            c3e.Add(1);
            return c3e;
        }
    }

    void TestAccessTypes()
    {
        // 3a: Unused
        IList<int> c3a = new List<int> { 4, 5 }; // BAD

        // 3b: Pass to function
        IList<int> c3b = new List<int> { }; // GOOD: used
        c3b.Add(1);
        f(c3b);

        // 3f: Access a property
        var c3f = new List<int>(); // GOOD: accessed
        c3f.Add(1);
        int zero = c3f.Count;
    }

    // Test 4: Initialization type

    private IList<int> c4a; // BAD: even though uninitialized

    void TestInitializationTypes()
    {
        // Test 4a: Uninitialized
        c4a.Add(1);

        // Test 4b: Constructed from new
        var c4b = new List<int>(); // BAD
        c4b.Add(1);

        // Test 4c: List initialized
        var c4c = new List<int> { 2, 3, 4 }; // BAD
        c4c.Add(1);

        // Test 4d: Constructed from other expression
        var c4d = f(); // GOOD
        c4d.Add(1);

        // Test 4e: In a foreach loop
        List<List<string>> c4e = new List<List<string>> { new List<string> { "x" } };

        foreach (var c4f in c4e) // GOOD: constructed from elsewehere
            c4f.Remove("x");

        int x = c4e.Count;
    }

    // Test 5: Assignment
    void TestAssignment()
    {
        // Assigned from new container
        IList<int> c5a; // BAD
        c5a = new List<int>();
        c5a.Add(1);

        // Assigned from something else
        IList<int> c5b; // GOOD: from f()
        c5b = f();
        c5b.Add(1);

        // Assigned to something
        IList<int> c5c = new List<int>(), c5d; // GOOD: assigned elsewhere
        c5c.Add(1);
        c5d = c5c;

        // Assigned in an expression somewhere
        IList<int> c5e = new List<int>(); // BAD: assigned in expr
        for (int i = 0; i < 10; c5e = new List<int>(), ++i)
            c5e.Add(1);

        IList<int> c5f = new List<int>(); // GOOD: assigned in expr
        for (int i = 0; i < 10; c5f = null, ++i)
            c5f.Add(1);

    }

    class NonCollection
    {
        public void Add(int i) { }
    }

    // Test 6: Collection type
    void TestCollections()
    {
        var c6a = new NonCollection(); // GOOD: not a collection
        c6a.Add(1);

        var c6b = new ArrayList(); // BAD
        c6b.Add(1);

        var c6c = new BitArray(32); // BAD
        c6c.SetAll(true);

        var c6d = new Hashtable(); // BAD
        c6d.Add(1, 2);

        var c6e = new Queue(); // BAD
        c6e.Enqueue(1);

        var c6f = new SortedList(); // BAD
        c6f.Add(1, 2);

        var c6g = new Stack(); // BAD
        c6g.Push(1);

        var c6h = new Dictionary<int, int>(); // BAD
        c6h.Add(1, 2);

        var c6i = new HashSet<int>(); // BAD
        c6i.Add(1);

        var c6j = new LinkedList<int>(); // BAD
        c6j.AddFirst(1);

        var c6k = new List<int>(); // BAD
        c6k.Add(1);

        var c6l = new Queue<int>(); // BAD
        c6l.Enqueue(1);

        var c6m = new SortedDictionary<int, int>(); // BAD
        c6m.Add(1, 2);

        var c6n = new SortedList<int, int>(); // BAD
        c6n.Add(1, 2);

        var c6o = new SortedDictionary<int, int>(); // BAD
        c6o.Add(1, 2);

        var c6p = new SortedSet<int>(); // BAD
        c6p.Add(1);

        var c6q = new Stack<int>(); // BAD
        c6q.Push(1);

        ICollection<int> c6u = new List<int>(); // BAD
        c6u.Add(1);

        IDictionary<int, int> c6v = new Dictionary<int, int>(); // BAD
        c6v.Add(1, 2);

        IEnumerable<int> c6w = new List<int>(); // GOOD
        c6w.GetEnumerator();

        IList<int> c6x = new List<int>(); // BAD
        c6x.Add(12);

        ISet<int> c6y = new HashSet<int>(); // BAD
        c6y.Add(1);
    }

    void TestDynamicAccess()
    {
        // GOOD: dynamic
        dynamic c7a = new List<int>();
        c7a.Add(1);

        // GOOD: cast to dynamic
        var c7b = new List<int>();
        c7b.Add(1);
        dynamic x = (dynamic)c7b;

        // GOOD: passed as param to InvokeMember
        var c7c = new List<int>();
        var t = typeof(List<int>);
        t.InvokeMember("Add", System.Reflection.BindingFlags.InvokeMethod, null, c7c, new Object[] { 1 });
    }

    IList<int> c8a = new List<int>(); // BAD: no attribute

    [Obsolete()]
    IList<int> c8b = new List<int>(); // GOOD: has attribute

    void TestAttributes()
    {
        c8a.Add(1);
        c8b.Add(2);
    }

    public static void Main(string[] args)
    {
        ContainerTest t = new ContainerTest();
    }

    IEnumerable<IList<string>> TestIndirectInitializations(IList<string>[] stringss)
    {
        foreach (var strings in stringss)
            strings.Add(""); // GOOD

        if (stringss[0] is List<String> l)
            l.Add(""); // GOOD

        switch (stringss[0])
        {
            case List<String> l2:
                l2.Add(""); // GOOD
                break;
        }

        return stringss;
    }

    void Out(out List<string> strings)
    {
        strings = new List<string> { "a", "b", "c" };
    }

    void OutTest()
    {
        Out(out var strings); // BAD: but allow for now (only C# 7 allows discards)
    }
}
