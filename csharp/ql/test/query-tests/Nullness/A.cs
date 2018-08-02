using System;

class A
{
    public void notTest()
    {
        object not_ok = null;
        if (!(!(!(not_ok == null))))
        {
            not_ok.GetHashCode();
        }
        object not = null;
        if (!(not != null))
        {
            not.GetHashCode();
        }
    }
    public void instanceOf()
    {
        object instanceof_ok = null;
        if (instanceof_ok is string)
        {
            instanceof_ok.GetHashCode();
        }
    }

    public void locked()
    {
        object synchronized_always = null;
        lock (synchronized_always)
        {
            synchronized_always.GetHashCode();
        }
    }

    public void assignIf()
    {
        string xx;
        string ok = null;
        if ((ok = (xx = null)) == null || ok.Length == 0)
        {
        }
    }
    public void assignIf2()
    {
        string ok2 = null;
        if (foo(ok2 = "hello") || ok2.Length == 0)
        {
        }
    }
    public void assignIfAnd()
    {
        string xx;
        string ok3 = null;
        if ((xx = (ok3 = null)) != null && ok3.Length == 0)
        {
        }
    }


    public bool foo(string o) { return false; }

    public void dowhile()
    {
        string do_ok = "";
        do
        {
            Console.WriteLine(do_ok.Length);
            do_ok = null;
        }
        while (do_ok != null);


        string do_always = null;
        do
        {
            Console.WriteLine(do_always.Length);
            do_always = null;
        }
        while (do_always != null);

        string do_maybe1 = null;
        do
        {
            Console.WriteLine(do_maybe1.Length);
        }
        while (do_maybe1 != null);

        string do_maybe = "";
        do
        {
            Console.WriteLine(do_maybe.Length);
            do_maybe = null;
        }
        while (true);
    }

    public void while_()
    {
        string while_ok = "";
        while (while_ok != null)
        {
            Console.WriteLine(while_ok.Length);
            while_ok = null;
        }

        bool TRUE = true;
        string while_always = null;
        while (TRUE)
        {
            Console.WriteLine(while_always.Length);
            while_always = null;

        }


        string while_maybe = "";
        while (true)
        {
            Console.WriteLine(while_maybe.Length);
            while_maybe = null;
        }

    }

    public void array_assign_test()
    {
        int[] array_null = null;
        array_null[0] = 10;

        int[] array_ok;
        array_ok = new int[10];
        array_ok[0] = 42;
    }

    public void if_()
    {
        string if_ok = "";
        if (if_ok != null)
        {
            Console.WriteLine(if_ok.Length);
            if_ok = null;
        }


        string if_always = null;
        if (if_always == null)
        {
            Console.WriteLine(if_always.Length);
            if_always = null;
        }

        string if_maybe = "";
        if (if_maybe != null && if_maybe.Length % 2 == 0)
        {
            if_maybe = null;
        }
        Console.WriteLine(if_maybe.Length);
    }

    public void for_()
    {
        string for_ok;
        for (for_ok = ""; for_ok != null; for_ok = null)
        {
            Console.WriteLine(for_ok.Length);
        }

        Console.WriteLine(for_ok.Length);


        for (string for_always = null; for_always == null; for_always = null)
        {
            Console.WriteLine(for_always.Length);
        }


        for (string for_maybe = ""; ; for_maybe = null)
        {
            Console.WriteLine(for_maybe.Length);
        }
    }

    public void access()
    {
        int[] arrayaccess = null;
        string[] fieldaccess = null;
        Object methodaccess = null;
        Object methodcall = null;

        Console.WriteLine(arrayaccess[1]);
        Console.WriteLine(fieldaccess.Length);
        Func<String> tmp = methodaccess.ToString;
        Console.WriteLine(methodcall.ToString());

        Console.WriteLine(arrayaccess[1]);
        Console.WriteLine(fieldaccess.Length);
        tmp = methodaccess.ToString;
        Console.WriteLine(methodcall.ToString());
    }

    public void out_or_ref()
    {
        object var_out = null;
        TestMethod1(out var_out);
        Console.WriteLine(var_out.ToString());

        object var_ref = null;
        TestMethod2(ref var_ref);
        Console.WriteLine(var_ref.ToString());
    }

    public void lambda_test()
    {
        string actual = null;

        MyDelegate fun = e => x => actual = e;

        fun("hello")("world");
        Console.WriteLine(actual.Length);
    }

    static void TestMethod1(out object num)
    {
        num = 42;
    }

    static void TestMethod2(ref object num)
    {
    }

    static void Main() { }
}
public delegate MyDelegate2 MyDelegate(string e);
public delegate void MyDelegate2(string e);

class B
{
    public void operatorCall()
    {
        B eq_call_always = null;
        B b2 = null;
        B b3 = null;
        B neq_call_always = null;

        if (eq_call_always == null)
            Console.WriteLine(eq_call_always.ToString());

        if (b2 != null)
            Console.WriteLine(b2.ToString());

        if (b3 == null) { }
        else
            Console.WriteLine(b3.ToString());

        if (neq_call_always != null) { }
        else
            Console.WriteLine(neq_call_always.ToString());



    }
    public static bool operator ==(B b1, B b2)
    {
        return Object.Equals(b1, b2);
    }
    public static bool operator !=(B b1, B b2)
    {
        return !(b1 == b2);
    }
}
public struct CoOrds
{
    public int x, y;


    public CoOrds(int p1, int p2)
    {
        x = p1;
        y = p2;
    }
}

public class Casts
{
    void test()
    {
        object o = null;
        if ((object)o != null)
        {
            // GOOD
            var eq = o.Equals(o);
        }
    }
}

public class Delegates
{
    delegate void Del();

    class Foo
    {
        public static void Run(Del d) { }
        public void Bar() { }
    }

    void F()
    {
        Foo foo = null;
        Foo.Run(delegate { foo = new Foo(); });
        foo.Bar();
    }
}
