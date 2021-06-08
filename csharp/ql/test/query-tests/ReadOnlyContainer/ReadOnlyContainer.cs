using System;
using System.Collections;
using System.Collections.Generic;

class Test
{
    // Test variable scope

    IList<int> v1 = new List<int>();  // BAD: private scope

    void f()
    {
        var v2 = new List<int>();   // BAD: local scope
        var x = v1.Contains(1);
        var y = v2.Contains(2);
    }

    public IList<int> n1 = new List<int>(); // GOOD: public
    protected IList<int> n2 = new List<int>();  // GOOD: protected

    void g()
    {
        n1.Contains(1);
        n2.Contains(2);
    }

    // Test initializer

    IList<int> n3 = new List<int> { 1, 2, 3 };  // GOOD: initialized
    IList<int> v3;  // BAD: unassigned

    void h()
    {
        n3.Contains(1);
        v3.Contains(1);
    }

    // Test variable uses

    void populate(IList<int> v)
    {
        v.Add(1);
    }

    void f1()
    {
        var n4 = new List<int>(); // GOOD: populated
        populate(n4);
        n4.Contains(1);

        var n5 = new List<int>(); // GOOD: assigned
        n5 = new List<int> { 1, 2, 3 };
        n5.Contains(1);

        var v4 = new List<int>(); // BAD: assigned only from empty list
        v4 = new List<int>();
        v4.Contains(1);

        var n5a = new List<int>();  // GOOD: Not used
    }

    // Test attributes

    [Obsolete()]
    IList<int> n6 = new List<int>();  // GOOD: attribute

    void f3()
    {
        n6.Contains(1);
    }

    // Test reading methods

    void f4()
    {
        var v5 = new Dictionary<int, int>();  // BAD
        v5.ContainsKey(1);
        v5.ContainsValue(1);
        v5.GetEnumerator();

        var tmp = new HashSet<int>();
        var v6 = new HashSet<int>();  // BAD
        v6.IsSubsetOf(tmp);
        v6.IsProperSubsetOf(tmp);
        v6.IsSupersetOf(tmp);
        v6.IsProperSupersetOf(tmp);

        var v7 = new LinkedList<int>(); // BAD
        v7.Contains(1);

        var v8 = new Queue<int>();    // BAD
        v8.Dequeue();
        v8.Peek();
        v8.ToArray();

        var v9 = new Stack<int>();    // BAD
        v9.Pop();

        var v10 = new List<int>();      // BAD: property access
        var x = v10.Count;
    }

    // Test writing methods

    void f5()
    {
        var n6 = new List<int>(); // GOOD: Add method
        n6.Add(1);
        n6.Contains(1);

        // UnknownMethod      // GOOD: other method
        var n7 = new List<int>();
        n7.GetType();
        n7.Contains(1);
    }

    // Test indexed access

    void f6()
    {
        var v11 = new Dictionary<int, int>(); // BAD: read by Index
        var x = v11[1];

        var n12 = new Dictionary<int, int>(); // GOOD: written by Index
        n12[1] = 2;
        x = n12[1];
    }

    // Test foreach

    void f7()
    {
        var l1 = new List<IList<int>> { new List<int>() };
        foreach (var n13 in l1)  // GOOD: from foreach
        {
            var x = n13.Count;
        }
    }

    // Test initialized with 'is'

    void f8(object arguments)
    {
        int c;
        if (arguments is IDictionary dict)  // GOOD
            c = dict.Count;

        switch (arguments)
        {
            case IDictionary dict2:  // GOOD
                c = dict2.Count;
                break;
        }
    }

    void f9()
    {
        var l1 = new MyList(); // BAD
        var x1 = l1[0];

        var l2 = new MyList(); // GOOD
        var x2 = l2[0];
        l2.Prop = 42;
    }

    class MyList : List<int>
    {
        public int Prop { get { return 0; } set { Add(value); } }
    }
}

// semmle-extractor-options: /r:System.Collections.dll
