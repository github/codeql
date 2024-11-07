using System;
using System.Collections.Generic;
using System.Collections.Concurrent;

namespace Semmle.Util;

public class MemoizedFunc<T1, T2> where T1 : notnull
{
    private readonly Func<T1, T2> f;
    private readonly Dictionary<T1, T2> cache = [];

    public MemoizedFunc(Func<T1, T2> f)
    {
        this.f = f;
    }

    public T2 Invoke(T1 s)
    {
        if (!cache.TryGetValue(s, out var t))
        {
            t = f(s);
            cache[s] = t;
        }
        return t;
    }
}

public class ConcurrentMemoizedFunc<T1, T2> where T1 : notnull
{
    private readonly Func<T1, T2> f;
    private readonly ConcurrentDictionary<T1, T2> cache = [];

    public ConcurrentMemoizedFunc(Func<T1, T2> f)
    {
        this.f = f;
    }

    public T2 Invoke(T1 s) => cache.GetOrAdd(s, f);
}