using System;

// BAD
class Incorrect
{
    public bool Equals(Incorrect other) => false;
}

// GOOD
class Normal
{
}

// GOOD: provides Equals method.
class Correct
{
    public override bool Equals(object o) => Equals((Correct)o);
    public bool Equals(Correct c) => false;
}

// GOOD: provides IEquatable.Equals method.
class MyEquatable : IEquatable<MyEquatable>
{
    public bool Equals(MyEquatable other) => false;
}

// GOOD: Implements Equals(object)
abstract class EqA<T> : IEquatable<T>
{
    public abstract bool Equals(T other);
    private bool Equals(int other) => false;
    public override bool Equals(object other) { return other != null && GetType() == other.GetType() && Equals((T)other); }
}

// GOOD: Implements Equals(object)
class EqB : EqA<EqB>
{
    private bool Equals(int other) => false;
    public override bool Equals(EqB other) => true;
}
