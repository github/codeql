using System;
using System.Collections.Generic;

class ToStringWithTypes<T>
{
    public void M(bool a) { }

    public void M(char a) { }

    public void M(sbyte a) { }

    public void M(short a) { }

    public void M(int a) { }

    public void M(long a) { }

    public void M(byte a) { }

    public void M(ushort a) { }

    public void M(uint a) { }

    public void M(ulong a) { }

    public void M(float a) { }

    public void M(double a) { }

    public void M(decimal a) { }

    public void M(object a) { }

    public void M(string a) { }

    public void M(char? a) { M(ref a); }

    public void M(int[,,,][][,][,,] a) { }

    unsafe public void M(int* a) { }

    public void M(dynamic a, dynamic b) { }

    public void M(IEnumerable<int> a) { }

    public void M(out T a) { a = default(T); }

    public void M<S>(ref S a) { }

    public void M<S>(params S[] a) { }

    public int this[T a, bool b] => 42;
}

class ToStringWithTypes
{
    public void M(__arglist) { }

    public delegate void Delegate<T>(int i, T t);

    public event Delegate<string> Event;
}

// semmle-extractor-options: /r:System.Dynamic.Runtime.dll /r:System.Linq.Expressions.dll
