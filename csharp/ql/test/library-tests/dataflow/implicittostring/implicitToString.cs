using System;

public class TestClass
{
    public class MyClass()
    {
        public override string ToString()
        {
            return "tainted";
        }
    }

    public static void Sink(object o) { }

    public void M1()
    {
        var x1 = new MyClass();
        var x2 = "Hello" + x1.ToString();
        Sink(x2);
    }

    public void M2()
    {
        var x1 = new MyClass();
        var x2 = "Hello" + x1;
        Sink(x2);
    }

    public void M3()
    {
        var x1 = new MyClass();
        var x2 = $"Hello {x1.ToString()}";
        Sink(x2);
    }

    public void M4()
    {
        var x1 = new MyClass();
        var x2 = $"Hello {x1}";
        Sink(x2);
    }

}
