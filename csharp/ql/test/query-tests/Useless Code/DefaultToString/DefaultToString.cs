using System;
using System.Text;

class DefaultToString
{
    void M()
    {
        var d = new DefaultToString();
        Console.WriteLine(d.ToString()); // BAD
        var s = "hello " + d; // BAD

        new A().ToString(); // GOOD
        new B().ToString(); // GOOD

        var ints = new int[] { 1, 2, 3 };
        Console.WriteLine(ints); // BAD
        Console.WriteLine(string.Join(", ", ints)); // GOOD

        s = "hello " + ints; // BAD
        s = "hello " + string.Join(", ", ints); // GOOD

        s = "" + NullableE; // GOOD

        E e = E.A;
        Console.WriteLine(e); // GOOD

        C c = new D();
        Console.WriteLine(c); // GOOD
    }

    class A
    {
        override public string ToString() { return "hello"; }
    }

    class B : A { }

    enum E { A, B }

    E? NullableE { get; set; }

    class C { }

    class D : C
    {
        override public string ToString() { return "D"; }
    }
}

// semmle-extractor-options: /r:System.Runtime.Extensions.dll
