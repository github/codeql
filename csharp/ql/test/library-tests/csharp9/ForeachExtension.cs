using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

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
    async Task Main()
    {
        IEnumerator<int> enumerator1 = Enumerable.Range(0, 10).GetEnumerator();
        foreach (var item in enumerator1)
        {
        }

        IAsyncEnumerator<int> enumerator2 = GetAsyncEnumerator();
        await foreach (var item in enumerator2)
        {
        }

        foreach (var item in 42)
        {
        }

        foreach (var i in new int[] { 1, 2, 3 }) // not extension
        {
        }
    }

    static async IAsyncEnumerator<int> GetAsyncEnumerator()
    {
        yield return 0;
        await Task.Delay(1);
        yield return 1;
    }
}
