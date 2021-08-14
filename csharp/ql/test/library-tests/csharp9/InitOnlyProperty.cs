using System;

public class Base
{
    public int Prop0 { get { return 1; } init { Prop1 = value; } }
    public virtual int Prop1 { get; init; }
    public virtual int Prop2 { get; set; }

}

public class Derived : Base
{
    public override int Prop1 { get; init; }
    public int Prop2
    {
        get { return 0; }
        init
        {
            System.Console.WriteLine(value);
            Prop1 = value;
            Prop0 = value;
        }
    }
}

public class C1
{
    public void M1()
    {
        var d = new Derived
        {
            Prop1 = 1,
            Prop2 = 2,
            Prop0 = 0
        };
    }
}
