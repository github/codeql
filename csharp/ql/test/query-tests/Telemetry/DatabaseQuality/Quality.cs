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
            MyProperty4 = { 1, 2, 3 }
        };
    }

    public int MyProperty1 { get; }
    public int MyProperty2 { get; } = 42;
    public Test MyProperty3 { get; set; }
    public List<int> MyProperty4 { get; }
    static int MyProperty5 { get; }
}
