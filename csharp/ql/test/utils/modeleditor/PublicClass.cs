using System;

namespace GitHub.CodeQL;

public class PublicClass
{
    public void stuff(String arg)
    {
        Console.WriteLine(arg);
    }

    public static void staticStuff(String arg)
    {
        Console.WriteLine(arg);
    }

    protected void nonPublicStuff(String arg)
    {
        Console.WriteLine(arg + Console.ReadLine());
    }

    internal void internalStuff(String arg)
    {
        Console.WriteLine(arg);
    }
}
