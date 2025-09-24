using System;

public class B : A<int>
{
    public override object ToObject(int t) => t;
}
