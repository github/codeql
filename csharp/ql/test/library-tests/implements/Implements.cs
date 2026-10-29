using System;

public interface I1
{
    object Prop { get; set; }
    void M1();
}

public interface I2
{
    object M2();
}

public class C : I1
{
    public object Prop { get; set; }
    public void M1() { }
}

public struct S : I1
{
    public object Prop { get; set; }
    public void M1() { }
    public object M2() { throw null; }
}

public ref struct RS1 : I1
{
    public object Prop { get; set; }
    public void M1() { }
    public object M2() { throw null; }
}

public ref struct RS2 : I1, I2
{
    public object Prop { get; set; }
    public void M1() { }
    public object M2() { throw null; }
}
