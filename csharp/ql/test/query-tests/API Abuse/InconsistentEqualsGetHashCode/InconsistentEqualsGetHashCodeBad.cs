using System;

class Bad // $ Alert
{
    private int id;

    public Bad(int Id) { this.id = Id; }

    public override bool Equals(object other)
    {
        if (other is Bad b && b.GetType() == typeof(Bad))
            return this.id == b.id;
        return false;
    }
}
