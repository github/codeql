using System;
using System.Collections.Generic;

public class DeadStoreOfLocal
{
    delegate int D();

    int fn(D d) { return d(); }

    public int M1()
    {
        int x = M2(); // BAD
        return (x = 1) + x; // GOOD
    }

    public int M2()
    {
        int x = 1; // GOOD
        return x + (x = 1); // BAD
    }

    public int M3()
    {
        return fn(() =>
        {
            int y;
            y = 1; // GOOD
            return y;
        });
    }

    public int M4()
    {
        return fn(delegate ()
        {
            int y;
            y = 1; // GOOD: Assignment in delegate function
            return y;
        });
    }

    public void M5()
    {
        int x = M3(); // BAD
    }

    public void M6()
    {
        int x = 42;
        x += 1; // BAD
    }

    public void M7()
    {
        int x = 42;
        x++; // BAD
    }

    public IEnumerable<string> M8(IEnumerable<string> source)
    {
        var count = 0; // GOOD
        foreach (var val in source)
        {
            yield return val;
            Console.WriteLine(++count); // GOOD
        }
    }

    public IEnumerable<string> M9(IEnumerable<string> source)
    {
        var count = 0; // GOOD
        foreach (var val in source)
        {
            count += 1; // GOOD
            yield return val;
            Console.WriteLine(count);
        }
    }

    public void M10(IEnumerable<string> source)
    {
        foreach (var val in source)
        { // BAD
        }
    }
}

public abstract class ExceptionsFlow
{
    public abstract void Process();

    public void F()
    {
        string info1 = "", info2 = "", extra, message = "";
        try
        {
            info1 = "Starting";                   // GOOD: Used in exception handler
            message = "Unsuccessful completion";  // GOOD: Used in finally
            Process();
            info2 = "Finishing";                  // GOOD: Used in exception handler
            extra = "Dead store here";            // BAD: Dead store
            Process();
            message = "Successful completion";    // GOOD: Used in finally
            info1 = "Used in handler";            // BAD: Used in handler, but not a reachable handler
        }
        catch (SystemException ex)
        {
            throw new Exception("Failure in " + info1, ex);
        }
        catch (Exception ex)
        {
            throw new Exception("Failure in " + info2, ex);
        }
        finally
        {
            Console.WriteLine(message);
        }
    }

    public void FinallyFlow1()
    {
        int stage = 0;
        try
        {
            Console.WriteLine("Stage " + stage);
            stage = 1;  // GOOD: Used in finally
            throw new Exception();
        }
        finally
        {
            Console.WriteLine("Stage " + stage);
        }
    }

    public void FinallyFlow2()
    {
        int stage = 0;
        try
        {
            Process();
        }
        catch (Exception ex) // BAD
        {
            Console.WriteLine("Stage " + stage);
            stage = 3;  // GOOD: Used in finally
            throw;
        }
        finally
        {
            Console.WriteLine("Stage " + stage);
        }
    }
}

public class OutParam
{
    public void Test()
    {
        int x;
        Fn(out x); // BAD
        Fn(out _); // GOOD
    }

    void Fn(out int x)
    {
        x = 0;
    }
}

public class AssignmentArrayAliasing
{
    public void Test(double[] x)
    {
        var y = x; // GOOD: y aliases an array that is accessed below
        y[0] %= 2;
    }
}

public class Captured
{
    delegate int D();

    int fn(D d) { return d(); }

    void M1()
    {
        var x = 1; // GOOD
        Action a = () =>
        {
            Console.WriteLine(x);
        };
        a();
    }

    void M2()
    {
        var x = M6(); // BAD [FALSE NEGATIVE]
        Action a = () =>
        {
            x = 1; // GOOD
            Console.WriteLine(x);
        };
        a();
    }

    void M3()
    {
        int x;
        Action a = () =>
        {
            x = 1; // BAD [FALSE NEGATIVE]
        };
        a();
    }

    void M4()
    {
        int x;
        Action a = () =>
        {
            x = 1; // GOOD
            Action aa = () =>
            {
                Console.WriteLine(x);
            };
            aa();
        };
        a();
    }

    void M5()
    {
        int x = 0; // BAD: NOT DETECTED
        Action a = () =>
        {
            x = 1; // GOOD
        };
        a();
        Console.WriteLine(x);
    }

    int M6()
    {
        fn(() =>
        {
            int y = M6(); // BAD
            return (y = 1) + y; // GOOD
        });

        int captured = 0; // GOOD: Variable captured variable
        fn(() => { return captured; });

        return captured = 1; // BAD: NOT DETECTED
    }

    void M7()
    {
        var y = 12; // GOOD: Not a dead store (used in delegate)
        fn(() =>
        {
            var x = y;  // BAD: Dead store in lambda
            return 0;
        });
    }

    Action A;
    void M8()
    {
        var cap = 0; // GOOD
        A = () => Console.WriteLine(cap);
        M9();
    }

    void M9()
    {
        A();
    }

    void M10(bool b)
    {
        var x = ""; // GOOD
        Action action;
        if (b)
            action = () => System.Console.WriteLine(x);
        else
            action = () => { };
        action();
    }
}

class Patterns
{
    void Test()
    {
        object o = null;
        if (o is int i1)
        { // GOOD
            Console.WriteLine($"int {i1}");
        }
        else if (o is var v1)
        { // BAD
        }

        switch (o)
        {
            case "xyz":
                break;
            case int i2 when i2 > 0: // GOOD
                Console.WriteLine($"positive {i2}");
                break;
            case int i3: // GOOD
                Console.WriteLine($"int {i3}");
                break;
            case var v2: // BAD
                break;
            default:
                Console.WriteLine("Something else");
                break;
        }
    }
}

class Tuples
{
    void M()
    {
        (int x, (bool b, string s)) = GetTuple(); // GOOD
        Use(x);
        Use(b);
        Use(s);
        (x, (b, s)) = GetTuple(); // BAD: `b`
        Use(x);
        Use(s);
        (x, (_, s)) = GetTuple(); // GOOD
        Use(x);
        Use(s);
    }

    (int, (bool, string)) GetTuple()
    {
        return (0, (false, ""));
    }

    static void Use<T>(T u) { }
}

class Initializers
{
    string M1()
    {
        var s = string.Empty; // "GOOD"
        s = "";
        return s;
    }

    string M2()
    {
        var s = ""; // "GOOD"
        s = "";
        return s;
    }

    string M3()
    {
        string s = null; // "GOOD"
        s = "";
        return s;
    }

    string M4()
    {
        var s = M3(); // BAD
        s = "";
        return s;
    }

    string M5()
    {
        var s = default(string); // "GOOD"
        s = "";
        return s;
    }

    string M6(bool b)
    {
        var s = "";
        if (b)
            s = "abc"; // GOOD
        if (b)
            return s;
        return null;
    }

    string M7(bool b)
    {
        var s = "";
        if (b)
            s = "abc"; // BAD
        if (!b)
            return s;
        return null;
    }

    string M8()
    {
        string s = default; // "GOOD"
        s = "";
        return s;
    }

    string M9()
    {
        var s = (string)null; // "GOOD"
        s = "";
        return s;
    }
}

class Anonymous
{
    int M(bool b)
    {
        var x = new { a = 0, b = 0 }; // GOOD
        if (b)
        {
            x = new { a = 1, b = 1 };
        }
        else
        {
            x = new { a = 2, b = 2 };
        }
        return x.a + x.b;
    }
}

class Finally
{
    int M(bool b)
    {
        int i = 0; // GOOD
        try
        {
            if (b)
                throw new Exception();
        }
        finally
        {
            i = 1; // GOOD
        }
        return i;
    }
}

public static class AnonymousVariable
{
    public static int Count<T>(this IEnumerable<T> items)
    {
        int count = 0;
        foreach (var _ in items) // GOOD
            count++;
        return count;
    }
}

public static class Using
{
    public static void M()
    {
        using var x = new System.IO.FileStream("", System.IO.FileMode.Open); // GOOD
        using var _ = new System.IO.FileStream("", System.IO.FileMode.Open); // GOOD

        using (var y = new System.IO.FileStream("", System.IO.FileMode.Open)) // BAD
        {
        }
    }
}