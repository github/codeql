using System;

public class MyAttributeTestClass
{
    public class MyAttribute : Attribute
    {
        public readonly string S;
        public MyAttribute(string s) => S = s;
    }

    [MyAttribute(nameof(T))]
    public void M1<T>(string x) { }

    [return: MyAttribute(nameof(y))]
    public string M2(string y) => y;

    public object M3([MyAttribute(nameof(z))] string z) => z;

    public object M4<S>([MyAttribute(nameof(S))] string z) => z;
}