using System;

namespace GitHub.CodeQL;

public interface PublicInterface
{
    void stuff(String arg);

    static void staticStuff(String arg)
    {
        Console.WriteLine(arg);
    }
}
