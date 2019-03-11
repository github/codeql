// semmle-extractor-options: /r:System.Security.Cryptography.Csp.dll /r:System.Security.Cryptography.Algorithms.dll /r:System.Security.Cryptography.Primitives.dll /r:System.Threading.Tasks.dll /r:System.Threading.Thread.dll /r:System.Linq.dll /r:System.Collections.dll /r:System.Threading.Tasks.Parallel.dll
using System;
using System.Linq;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using System.Security.Cryptography;

class DirectUsagePositiveCase
{
    public static void Run(int max)
    {
        const int threadCount = 4;

        // This variable is used in multiple threads
        var sha1 = SHA1.Create();
        Action start = () => {
            for (int i = 0; i < max; i++)
            {
                var bytes = new byte[4];
                sha1.ComputeHash(bytes);
            }
        };

        // BUG expected
        var threads = Enumerable.Range(0, threadCount)
                                .Select(_ => new ThreadStart(start))
                                .Select(x => new Thread(x))
                                .ToList();
        foreach (var t in threads) t.Start();
        foreach (var t in threads) t.Join();
    }
}

class DirectUsageNegativeCase
{
    public static void Run(int max)
    {
        const int threadCount = 4;
        Action start = () => {
            for (int i = 0; i < max; i++)
            {
                var sha1 = SHA1.Create();
                var bytes = new byte[4];
                sha1.ComputeHash(bytes);
            }
        };
        var threads = Enumerable.Range(0, threadCount)
                                .Select(_ => new ThreadStart(start))
                                .Select(x => new Thread(x))
                                .ToList();
        foreach (var t in threads) t.Start();
        foreach (var t in threads) t.Join();
    }
}

public class Nest01
{
    private readonly SHA256 _sha;

    public Nest01()
    {
        _sha = SHA256.Create();
    }

    public byte[] ComputeHash(byte[] bytes)
    {
        return _sha.ComputeHash(bytes);
    }
}

class IndirectUsagePositiveCase
{
    public static void Run(int max)
    {
        const int threadCount = 4;
        // This variable is used in multiple threads
        var sha1 = new Nest01();

        // BUG expected
        Action start = () => {
            for (int i = 0; i < max; i++)
            {
                var bytes = new byte[4];
                sha1.ComputeHash(bytes);
            }
        };
        var threads = Enumerable.Range(0, threadCount)
                                .Select(_ => new ThreadStart(start))
                                .Select(x => new Thread(x))
                                .ToList();
        foreach (var t in threads) t.Start();
        foreach (var t in threads) t.Join();
    }
}

class IndirectUsageNegativeCase
{
    public static void Run(int max)
    {
        const int threadCount = 4;
        Action start = () => {
            for (int i = 0; i < max; i++)
            {
                var sha1 = new Nest01();
                var bytes = new byte[4];
                sha1.ComputeHash(bytes);
            }
        };
        var threads = Enumerable.Range(0, threadCount)
                                .Select(_ => new ThreadStart(start))
                                .Select(x => new Thread(x))
                                .ToList();
        foreach (var t in threads) t.Start();
        foreach (var t in threads) t.Join();
    }
}

class LambdaNotStart
{
    public static void Run()
    {
        var sha1 = SHA1.Create();

        Func<string> myFunc = () =>
        {
            var bytes = new byte[4];
            return Convert.ToBase64String(sha1.ComputeHash(bytes));
        };

        var d = myFunc.DynamicInvoke();
    }
}

class ParallelInvoke
{
    public static void Run()
    {
        var sha1 = SHA1.Create();

        try
        {
            Parallel.Invoke(() =>
                {
                    var bytes = new byte[4];
                    Convert.ToBase64String(sha1.ComputeHash(bytes));
                },
                () =>
                {
                    var bytes = new byte[4];
                    Convert.ToBase64String(sha1.ComputeHash(bytes));
                }
            );

        }
        catch (AggregateException e)
        {
            Console.WriteLine("An action has thrown an exception. THIS WAS UNEXPECTED.\n{0}", e.InnerException.ToString());
        }
    }

}
