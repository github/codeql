using System;

public class Class1
{
    public virtual Class1 M1() { return new(); }
    public virtual Class1 M2() { return new(); }
}

public class Class2 : Class1
{
    public override Class1 M1() { return new(); }
    public override Class2 M2() { return new(); }
}