using System;
using System.Collections;
using System.Collections.Generic;

class SystemTest : IEquatable<SystemTest>, IComparer, IComparer<SystemTest>, IComparable, IComparable<SystemTest>
{
    public override bool Equals(object other)
    {
        return Equals(this, other) || ReferenceEquals(this, other);
    }

    public override int GetHashCode()
    {
        return 1;
    }

    public bool Equals(SystemTest other)
    {
        return false;
    }

    public int Compare(object x, object y)
    {
        return 0;
    }

    public int Compare(SystemTest x, SystemTest y)
    {
        return 0;
    }

    int IComparable.CompareTo(object other)
    {
        return 0;
    }

    int IComparable<SystemTest>.CompareTo(SystemTest other)
    {
        return 0;
    }
}
