using System;
using System.Collections.Generic;

static class Extensions
{
    public static IEnumerator<T> GetEnumerator<T>(this IEnumerator<T> enumerator) => enumerator;
    public static IAsyncEnumerator<T> GetAsyncEnumerator<T>(this IAsyncEnumerator<T> enumerator) => enumerator;
    public static IEnumerator<int> GetEnumerator(this int count)
    {
        for (int i = 0; i < count; i++)
        {
            yield return i;
        }
    }
}

class Program
{
    void Main()
    {
        IEnumerator<int> enumerator = Enumerable.Range(0, 10).GetEnumerator();

        foreach (var item in enumerator)
        {
            Console.WriteLine(item);
        }

        IAsyncEnumerator<int> enumerator = GetAsyncEnumerator();
        await foreach (var item in enumerator)
        {
            Console.WriteLine(item);
        }

        foreach (var item in 42)
        {
            Console.WriteLine(item);
        }
    }

    static async IAsyncEnumerator<int> GetAsyncEnumerator()
    {
        yield return 0;
        await Task.Delay(1);
        yield return 1;
    }
}