using System;
using System.Collections.Generic;

public class Test
{
    static Test()
    {
        MyProperty5 = 42;
    }

    public Test()
    {
        MyProperty1 = 42;
        var x = nameof(MyProperty3);
        var y = nameof(MyProperty3.MyProperty2);

        new Test()
        {
            MyProperty4 = { 1, 2, 3 },
            MyProperty6 = { [1] = "" }
        };

        Event1.Invoke(this, 5);

        var str = "abcd";
        var sub = str[..3];

        Span<int> sp = null;
        var slice = sp[..3];

        Span<byte> guidBytes = stackalloc byte[16];
        guidBytes[08] = 1;
    }

    public int MyProperty1 { get; }
    public int MyProperty2 { get; } = 42;
    public Test MyProperty3 { get; set; }
    public List<int> MyProperty4 { get; }
    static int MyProperty5 { get; }
    public Dictionary<int, string> MyProperty6 { get; }

    public event EventHandler<int> Event1;

    class Gen<T> where T : new()
    {
        public static T Factory()
        {
            return new T();
        }
    }
}
