using System;

namespace GitHub.CodeQL;

public interface PublicGenericInterface<T>
{
    void stuff(T arg);

    void stuff2<T2>(T2 arg);

    static void staticStuff(String arg)
    {
        Console.WriteLine(arg);
    }
}
