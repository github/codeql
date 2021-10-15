using System;

class GoodNotIComparable
{
    public int CompareTo(object other) { return 0; }
}

class GoodComparable : IComparable
{
    public int CompareTo(object other) { return 0; }
    public override bool Equals(object other) { return false; }
    public override int GetHashCode() { return 0; }
}

class GoodComparableT<T> : IComparable<T>
{
    public int CompareTo(T other) { return 0; }
    public override bool Equals(object other) { return false; }
    public override int GetHashCode() { return 0; }
}

class GoodComparableInt : IComparable<int>
{
    public int CompareTo(int other) { return 0; }
    public override bool Equals(object other) { return false; }
    public override int GetHashCode() { return 0; }
}

abstract class GoodComparableAbstract : IComparable
{
    public abstract int CompareTo(object other);
}

class BadComparable : IComparable
{
    public int CompareTo(object other) { return 0; }
    public override int GetHashCode() { return 0; }
}

class BadComparableInt : IComparable<int>
{
    public int CompareTo(int x) { return 0; }
    public override int GetHashCode() { return 0; }
}

class BadComparableT<T> : IComparable<T>
{
    public int CompareTo(T t) { return 0; }
    public override int GetHashCode() { return 0; }
}

class BadComparableNewEquals : IComparable
{
    public int CompareTo(object other) { return 0; }
    public new bool Equals(object other) { return false; }
}
