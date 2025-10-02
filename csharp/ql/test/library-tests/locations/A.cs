using System;

public abstract class A<T>
{
    public abstract T Prop { get; }
    public abstract T this[int index] { get; set; }
    public abstract event EventHandler Event;
    public void Apply(T t) { }
    public abstract object ToObject(T t);
}

public class A2 : A<string>
{
    public override string Prop => "";

    public override string this[int i]
    {
        get { return ""; }
        set { }
    }

    public override event EventHandler Event
    {
        add { }
        remove { }
    }

    public override object ToObject(string t) => t;

    public void M()
    {
        A2 other = new();
        other.Apply("");
    }
}
