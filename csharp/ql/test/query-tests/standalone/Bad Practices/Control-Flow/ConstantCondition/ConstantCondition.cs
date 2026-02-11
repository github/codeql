using System;

partial class C1
{
    public C2 Prop { get; set; }
}

class C2 { }

class ConstantMatching
{
    void M1()
    {
        var c1 = new C1();
        if (c1.Prop is int) // $ Alert
        {
        }

        // Should not be considered a constant condition as
        // we don't know anything about D.
        var d = new D();
        if (d.Prop is C2)
        {
        }
    }
}

