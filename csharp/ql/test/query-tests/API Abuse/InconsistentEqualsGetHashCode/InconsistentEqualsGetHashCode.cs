using System;

class ClassMissingGetHashCode
{
    public override bool Equals(object other)
    {
        return false;
    }

    public new int GetHashCode()
    { // not overridden
        return 42;
    }
}

class ClassMissingEquals
{
    public new bool Equals(object other)
    { // not overridden
        return false;
    }

    public override int GetHashCode()
    {
        return 42;
    }
}

class Class
{
    public override bool Equals(object other)
    {
        return false;
    }

    public override int GetHashCode()
    {
        return 42;
    }
}
