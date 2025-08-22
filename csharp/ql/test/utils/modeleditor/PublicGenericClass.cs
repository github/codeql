using System;

namespace GitHub.CodeQL;

public class PublicGenericClass<T, T2> : PublicGenericInterface<T>
{
    public void stuff(T arg)
    {
        Console.WriteLine(arg);
    }

    public void stuff2<T2>(T2 arg)
    {
        Console.WriteLine(arg);
    }

    public TNode summaryStuff<TNode>(TNode arg)
    {
        return arg;
    }
}
