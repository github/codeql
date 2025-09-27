using System;

public abstract class A<T>
{
    public void Apply(T t) { }
    public abstract object ToObject(T t);
}

public class A2 : A<string>
{
    public override object ToObject(string t) => t;

    public void M()
    {
        A2 other = new();
        other.Apply("");
    }
}
