using System;

public class B : A<int>
{
    public override int Prop => 0;

    public override int this[int i]
    {
        get { return 0; }
        set { }
    }

    public override event EventHandler Event
    {
        add { }
        remove { }
    }

    public override object ToObject(int t) => t;
}
