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
        var sub = str[..3];         // TODO: this is not an indexer call, but rather a `str.Substring(0, 3)` call.

        Span<int> sp = null;
        var slice = sp[..3];        // TODO: this is not an indexer call, but rather a `sp.Slice(0, 3)` call.

        Span<byte> guidBytes = stackalloc byte[16];
        guidBytes[08] = 1;          // TODO: this indexer call has no target, because the target is a `ref` returning getter.

        new MyList([new(), new Test()]);
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

    class MyList
    {
        public MyList(IEnumerable<Test> init) { }
    }
}
