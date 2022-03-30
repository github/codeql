namespace System
{
    public interface IComparable
    {
        int CompareTo(object obj); // GOOD: the very definition of IComparable.CompareTo()
    }

    public interface IComparable<in T>
    {
        int CompareTo(T other);  // GOOD: the very definition of IComparable<T>.CompareTo()
    }
}

class C1<T>
{
    public int CompareTo(T other) => throw null; // BAD
}

class C2 { }

class C3 { }

class C4 : C1<C2> { }

class C5 : C1<C3> { }

class C6<T> : System.IComparable<T>
{
    public int CompareTo(T other) => throw null; // GOOD
}

class C7 : C6<C2> { }
