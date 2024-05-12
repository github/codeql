using System;

namespace GitHub.CodeQL;

public interface PublicInterface
{
    void stuff(String arg);

    string PublicProperty { get; set; }

    static void staticStuff(String arg)
    {
        Console.WriteLine(arg);
    }
}
