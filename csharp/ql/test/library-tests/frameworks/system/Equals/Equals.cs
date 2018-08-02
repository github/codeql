using System;

class NoEquals { }

class Equals1
{
    public override bool Equals(object other) => false;
}

abstract class Equals2<T> : IEquatable<T>
{
    public abstract bool Equals(T other);
    public override bool Equals(object other) { return other != null && GetType() == other.GetType() && Equals((T)other); }
}

class Equals3 : Equals2<Equals3>
{
    public override bool Equals(Equals3 other) => true;
}

struct NoEqualsStruct { }

struct Equals1Struct
{
    public override bool Equals(object other) => false;
}
