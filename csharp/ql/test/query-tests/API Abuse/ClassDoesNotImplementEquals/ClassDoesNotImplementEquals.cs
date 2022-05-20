using System;

// BAD
class Incorrect
{
    public static bool operator ==(Incorrect a, Incorrect b) => default(bool);
    public static bool operator !=(Incorrect a, Incorrect b) => !(a == b);
}

// GOOD
class Normal
{
}

// GOOD: provides Equals method.
class Correct
{
    public override bool Equals(object o) => default(bool);
    public static bool operator ==(Correct a, Correct b) => default(bool);
    public static bool operator !=(Correct a, Correct b) => !(a == b);
}

// BAD: needs to redefine Equals
class IncorrectOverrides : Correct
{
    public static bool operator ==(IncorrectOverrides a, IncorrectOverrides b) => default(bool);
    public static bool operator !=(IncorrectOverrides a, IncorrectOverrides b) => !(a == b);
}

// GOOD: abstract
abstract class Abstract
{
    public static bool operator ==(Abstract a, Abstract b) => default(bool);
    public static bool operator !=(Abstract a, Abstract b) => !(a == b);
}

class Program
{
    static void Main(string[] args)
    {
        // BAD: Call to missing equals method
        var b = new IncorrectOverrides().Equals(null);

        // GOOD:
        b = default(Abstract).Equals(null);
    }
}

// BAD: should also implement Equals.
class MyEquatable : IEquatable<MyEquatable>
{
    public bool Equals(MyEquatable other)
    {
        return value == other.value;
    }

    int value;
}

// GOOD: Implements Equals(object)
abstract class EqA<T> : IEquatable<T>
{
    public abstract bool Equals(T other);
    public override bool Equals(object other) { return other != null && GetType() == other.GetType() && Equals((T)other); }
}

// GOOD: handled by based class
class EqB : EqA<EqB>
{
    public override bool Equals(EqB other)
    {
        return true;
    }
}
