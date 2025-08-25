using System;
using System.Text;

public class DefaultToString
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

        var sb = new StringBuilder();
        sb.Append(new char[] { 'a', 'b', 'c' }, 0, 3); // GOOD

        IPrivate f = null;
        Console.WriteLine(f);  // BAD

        IPublic g = null;
        Console.WriteLine(g);  // GOOD

        Console.WriteLine(new ValueTuple<int, int>(1, 2)); // GOOD

        Console.WriteLine((1, 2)); // GOOD

        var t1 = new ValueTuple<int, DefaultToString>(1, new DefaultToString());
        Console.WriteLine(t1); // BAD

        var t2 = new ValueTuple<A, D>(new A(), new D());
        Console.WriteLine(t2); // GOOD
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

    public interface IPublic
    {
    }

    private interface IPrivate
    {
    }
}
