using System;

public abstract class A<T>
{
    public abstract T Prop { get; }
    public abstract T this[int index] { get; set; }
    public abstract event EventHandler Event;
    public void Apply(T t1) { }
    public abstract object ToObject(T t2);
    public object Field;
    public A() { }
    public A(T t) { }
    ~A() { }
    public static A<T> operator +(A<T> a1, A<T> a2) { return a1; }
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
