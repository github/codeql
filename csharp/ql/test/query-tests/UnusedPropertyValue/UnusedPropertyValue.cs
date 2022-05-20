using System;

class Program
{
    bool x;

    bool Prop1
    {
        set { x = true; } // BAD
    }

    bool Prop2
    {
        set { } // BAD
    }

    bool Prop3
    {
        get;
        set; // GOOD
    }

    bool Prop4
    {
        set { x = value; } // GOOD
    }

    bool Prop5
    {
        set { throw new NotImplementedException(); } // GOOD
    }
}

interface I1
{
    bool Prop1 { set; } // GOOD
}

class C1 : I1
{
    public bool Prop1
    {
        set { } // GOOD: virtual
    }
}

abstract class C2
{
    public virtual bool Prop1 { set { } } // GOOD: virtual
    public abstract bool Prop2 { set; }   // GOOD: abstract, no body
    public virtual bool Prop3 { set { } } // GOOD: virtual
}

class C3 : C2
{
    public bool Prop1
    {
        set { } // BAD: not override
    }

    public override bool Prop2
    {
        set { }  // GOOD: override
    }

    public override bool Prop3
    {
        set { } // GOOD: override
    }

    bool Prop4
    {
        set { throw new NotImplementedException(); } // GOOD: throw
    }
}
