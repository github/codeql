using System;

namespace GitHub.CodeQL;

public class PublicClass : PublicInterface
{
    public void stuff(String arg)
    {
        Console.WriteLine(arg);
    }

    public static void staticStuff(String arg)
    {
        Console.WriteLine(arg);
    }

    protected void protectedStuff(String arg)
    {
        Console.WriteLine(arg + Console.ReadLine());
    }

    private void privateStuff(String arg)
    {
        Console.Write(Console.BackgroundColor);
        Console.ForegroundColor = ConsoleColor.Red;
    }

    internal void internalStuff(String arg)
    {
        Console.WriteLine(arg);
    }

    string PublicInterface.PublicProperty { get; set; }

    public string summaryStuff(String arg)
    {
        return arg;
    }

    public string sourceStuff()
    {
        return "stuff";
    }

    public void sinkStuff(String arg)
    {
        // do nothing
    }

    public void neutralStuff(String arg)
    {
        // do nothing
    }
}
