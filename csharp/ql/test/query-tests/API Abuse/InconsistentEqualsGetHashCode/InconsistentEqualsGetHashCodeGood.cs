using System;

class Good
{
    private int id;

    public Good(int Id) { this.id = Id; }

    public override bool Equals(object other)
    {
        if (other is Good b && b.GetType() == typeof(Good))
            return this.id == b.id;
        return false;
    }

    public override int GetHashCode() => id;
}
