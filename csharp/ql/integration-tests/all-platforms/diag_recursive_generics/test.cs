public class GenA<U> { };
public class GenB<T> : GenA<GenB<GenB<T>>> { };

class P<T> { }
class C<U, V> : P<D<V, U>> { }
class D<W, X> : P<C<W, X>> { }

class A<T> : System.IEquatable<A<T>>
{
    public bool Equals(A<T> other) { return true; }
}

public class Class
{
    public static int Main()
    {
        GenB<string> a = new GenB<string>();
        P<D<string, int>> b = new C<int, string>();
        A<string> c = new A<string>();

        return 0;
    }
}
