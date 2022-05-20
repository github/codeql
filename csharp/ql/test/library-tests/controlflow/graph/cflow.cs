using System;

public class ControlFlow
{
    static void Main(string[] args)
    {
        int a = args.Length;

        a = new ControlFlow().Switch(a);

        if (a > 3)
            Console.WriteLine("more than a few");

        while (a > 0)
        {
            Console.WriteLine(a-- * 100);
        }

        do
        {
            Console.WriteLine(-a++);
        } while (a < 10);

        for (int i = 1; i <= 20; i++)
        {
            if (i % 3 == 0 && i % 5 == 0)
                Console.WriteLine("FizzBuzz");
            else if (i % 3 == 0)
                Console.WriteLine("Fizz");
            else if (i % 5 == 0)
                Console.WriteLine("Buzz");
            else
                Console.WriteLine(i);
        }
    }

    private int Switch(int a)
    {
        switch (a)
        {
            case 1:
                Console.WriteLine("1");
                goto case 2;
            case 2:
                Console.WriteLine("2");
                goto case 1;
            case 3:
                Console.WriteLine("3");
                break;
        }
        switch (a)
        {
            case 42:
                Console.WriteLine("The answer");
                break;
            default:
                Console.WriteLine("Not the answer");
                break;
        }
        switch (int.Parse(Field))
        {
            case 0:
                if (!(Field == ""))
                    throw new NullReferenceException();
                break;
        }
        return a;
    }

    private void M(string s)
    {
        if (s == null)
            return;
        if (s.Length > 0)
        {
            Console.WriteLine(s);
        }
        else
        {
            Console.WriteLine("<empty string>");
        }
    }

    private void M2(string s)
    {
        if (s != null && s.Length > 0)
            Console.WriteLine(s);
    }

    private void M3(string s)
    {
        if (Equals(s, null))
            throw new ArgumentNullException("s");
        Console.WriteLine(s);

        if (Field != null)
            Console.WriteLine(new ControlFlow().Field);

        if (Field != null)
            Console.WriteLine(this.Field);

        if (this.Prop != null)
            Console.WriteLine(Prop);
    }

    private void M4(string s)
    {
        if (s != null)
        {
            while (true)
            {
                Console.WriteLine(s);
            }
            Console.WriteLine(s); // dead
        }
        Console.WriteLine(s);
    }

    private string M5(string s)
    {
        var x = s;
        x = x + " ";
        return x;
    }

    string Field;
    string Prop { get { return Field == null ? "" : Field; } set { Field = value; } }

    ControlFlow(string s)
    {
        Field = s;
    }

    ControlFlow(int i) : this(i + "") { }

    public ControlFlow() : this(0 + 1) { }

    public static ControlFlow operator +(ControlFlow x, ControlFlow y)
    {
        Console.WriteLine(x);
        return y;
    }

    public string this[int i] { get { return i + ""; } set { } }

    void For()
    {
        int x = 0;
        for (; x < 10; ++x)
            Console.WriteLine(x);

        for (; ; x++)
        {
            Console.WriteLine(x);
            if (x > 20)
                break;
        }

        for (; ; )
        {
            Console.WriteLine(x);
            x++;
            if (x > 30)
                break;
        }

        for (; x < 40;)
        {
            Console.WriteLine(x);
            x++;
        }

        for (int i = 0, j = 0; i + j < 10; i++, j++)
        {
            Console.WriteLine(i + j);
        }
    }

    void Lambdas()
    {
        Func<int, int> y = x => x + 1;
        Func<int, int> z = delegate (int x) { return x + 1; };
    }

    void LogicalOr()
    {
        if (1 == 2 || 2 == 3 || (1 == 3 && 3 == 1))
            Console.WriteLine("This shouldn't happen");
        else
            Console.WriteLine("This should happen");
    }

    void Booleans()
    {
        var b = Field.Length > 0 && !(Field.Length == 1);

        if (!(Field.Length == 0 ? false : true))
            b = Field.Length == 0 ? false : true;

        if (!(Field.Length == 0) || !!(Field.Length == 1 && b))
        {
            {
                throw new Exception();
            }
        }
    }

    void Do()
    {
        do
        {
            Field += "a";
            if (Field.Length > 0)
            {
                continue;
            }
            if (Field.Length < 0)
            {
                break;
            }
        } while (Field.Length < 10);
    }

    void Foreach()
    {
        foreach (var x in System.Linq.Enumerable.Repeat("a", 10))
        {
            Field += x;
            if (Field.Length > 0)
            {
                continue;
            }
            if (Field.Length < 0)
            {
                break;
            }
        }
    }

    void Goto()
    {
    Label: if (!!(Field.Length == 0)) { }

        if (Field.Length > 0) goto Label;

        switch (Field.Length + 3)
        {
            case 0:
                goto default;
            case 1:
                Console.WriteLine(1);
                break;
            case 2:
                goto Label;
            default:
                Console.WriteLine(0);
                break;
        }
    }

    System.Collections.Generic.IEnumerable<int> Yield()
    {
        yield return 0;
        for (int i = 1; i < 10; i++)
        {
            yield return i;
        }
        try
        {
            yield break;
            Console.WriteLine("dead code"); // dead
        }
        finally
        {
            Console.WriteLine("not dead");
        }
    }
}

public class ControlFlowSub : ControlFlow
{
    ControlFlowSub() : base() { }

    ControlFlowSub(string s) : this() { }

    ControlFlowSub(int i) : this(i.ToString()) { }
}

class DelegateCall
{
    string M(Func<int, string> f) => f(0);
}

class NegationInConstructor
{
    NegationInConstructor(bool b, int i, string s) { }

    void M(int i, string s, bool b)
    {
        new NegationInConstructor(i: 0, b: !(i > 0) && s != null, s: "");
    }
}

class LambdaGetter
{
    private static Func<object, string, object> _getter => (o, n) =>
    {
        object x = o;
        return x;
    };
}