using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;

namespace Summaries;

public class Theorems1<T> {
    
    public T Prop {
        get { throw null; }
        set { throw null; }
    }

    public Theorems1(T t)  { throw null; } 

    public T Get() { throw null; }

    public T Get(object x) { throw null; }

    public T Id(T x) { throw null; }

    public S Transform<S>(S x) { throw null; }

    public void Set(T x) { throw null; }

    public void Set(int x, T y) { throw null; }

    // No summary as S is unrelated to T
    public void Set<S>(S x) { throw null; }

    public int Apply(Func<T, int> f) { throw null; }

    public IList<T> GetMany() { throw null; }

    public void AddMany(IEnumerable<T> xs) { throw null; }
}

// It is assumed that this is a collection with elements of type T.
public class CollectionTheorems1<T> : IEnumerable<T> {
    IEnumerator<T> IEnumerable<T>.GetEnumerator() { throw null; }
    IEnumerator IEnumerable.GetEnumerator() { throw null; }

    public T First() { throw null; }

    public void Add(T x) { throw null; }

    public ICollection<T> GetMany() { throw null; }

    public void AddMany(IEnumerable<T> x) { throw null; }
}

// It is assumed that this is NOT a collection with elements of type T.
public class CollectionTheorems2<T> : IEnumerable {
    IEnumerator IEnumerable.GetEnumerator() { throw null; }

    public T Get() { throw null; }

    public void Set(T x) { throw null; }
}