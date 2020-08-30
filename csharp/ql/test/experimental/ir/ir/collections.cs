using System.Collections.Generic;

public class Collections
{
    class MyClass
    {
        public string a;
        public string b;
    }

    public static void Main()
    {
        var dict = new Dictionary<int, MyClass>()
        {
            { 0, new MyClass { a="Hello", b="World" } },
            { 1, new MyClass { a="Foo", b="Bar" } }
        };
    }
}
