using System;

class ForwardingTests
{
    void Fn()
    {
        string s = null;

        if (!s.IsNullOrEmpty())
        {
            Console.WriteLine(s.Length); // GOOD
        }

        if (s.IsNotNullOrEmpty())
        {
            Console.WriteLine(s.Length); // GOOD
        }

        if (!s.IsNull())
        {
            Console.WriteLine(s.Length); // GOOD
        }

        if (s.IsNotNull())
        {
            Console.WriteLine(s.Length); // GOOD
        }

        if (IsNotNull(s))
        {
            Console.WriteLine(s.Length); // GOOD
        }

        if (IsNotNullWrong(s))
        {
            Console.WriteLine(s.Length); // BAD (always)
        }

        AssertIsNotNull(s);
        Console.WriteLine(s.Length); // GOOD (false positive)
    }

    bool IsNotNull(object o)
    {
        return o is string ? !string.IsNullOrEmpty((string)o) : !o.IsNull();
    }

    bool IsNotNullWrong(object o)
    {
        if (o is string)
        {
            return !string.IsNullOrEmpty((string)o);
        }
        return true;
    }

    void AssertIsNotNull(object o)
    {
        if (o == null)
            throw new NullReferenceException();
    }
}

public static class ExtensionMethods
{
    public static bool IsNullOrEmpty(this string s)
    {
        return string.IsNullOrEmpty(s);
    }

    public static bool IsNotNullOrEmpty(this string s)
    {
        return !string.IsNullOrEmpty(s);
    }

    public static bool IsNull(this object o)
    {
        return ReferenceEquals(o, null);
    }

    public static bool IsNotNull(this object o)
    {
        return o != null;
    }
}
