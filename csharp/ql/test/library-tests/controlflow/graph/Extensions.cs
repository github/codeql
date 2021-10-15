using System;

public static class Extensions
{
    public static int ToInt32(this string s)
    {
        return Int32.Parse(s);
    }

    public static bool ToBool(this string s, Func<string, bool> f)
    {
        return f(s);
    }

    public static int CallToInt32() => ToInt32("0");
}

static class TestExtensions
{
    static void Main(string s)
    {
        s.ToInt32();
        Extensions.ToInt32("");
        Extensions.ToBool("true", bool.Parse);
        "true".ToBool(bool.Parse);
    }
}
