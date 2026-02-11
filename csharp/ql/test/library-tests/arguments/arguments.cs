using System;
using System.Collections.Generic;

class ArgumentsTest
{
    public ArgumentsTest(int x = 0, int y = 0)
    {
    }

    public ArgumentsTest(int x, out int y, ref int z)
    {
        y = x;
    }

    void f1(int x = 1, int y = 2)
    {
    }

    void f2(int x, out int y, ref int z)
    {
        y = x;
    }

    void f()
    {
        int x = 1;

        f1(y: 2);
        f2(x, out x, ref x);
        new ArgumentsTest(x, out x, ref x);
        new ArgumentsTest(y: 10, x: 5);
    }

    void f3(int o, params int[] args)
    {
        f3(0, 1, 2);
        f3(0, new int[] { 1, 2 });
        f3(args: 1, o: 0);
        f3(0, args);
        f3(args: args, o: 0);
        f3(args: new int[] { 1, 2 }, o: 0);
        short s1 = 1, s2 = 2;
        f3(0, s1, s2);
    }

    void f4(params object[] args)
    {
        f4(new object[] { null }, null);
    }

    int Prop { get; set; }

    int this[int a, int b] { get => a + b; set { } }

    void f5()
    {
        Prop = 0;
        Prop = this[1, 2];
        (Prop, this[3, 4]) = (5, 6);
        Prop++;
        Prop += 7;
        this[8, 9]++;
        this[10, 11] += 12;
        var tuple = (13, 14);
        (Prop, this[15, 16]) = tuple;
    }

    [MyAttribute(false)]
    void f6() { }

    [MyAttribute(true, y = "", x = 0)]
    void f7() { }

    void f8<T>(int o, params T[] args)
    {
        f8(0, args[0], args[1]);
        f8(0, new T[] { args[0], args[1] });
        f8(0, args);
        f8(args: args, o: 0);

        f8<double>(0, 1.1, 2.2);
        f8<double>(0, new double[] { 1.1, 2.2 });

        f8<double>(0, 1, 2);
        f8<double>(0, new double[] { 1, 2 });
        f8<double>(0, new double[] { 1, 2 });
    }

    void f9<T>(int o, params List<T> args)
    {
        f9(0, args[0], args[1]);
        f9(0, [args[0], args[1]]);
        f9(0, args);
        f9(args: args, o: 0);

        f9<double>(0, 1.1, 2.2);
        f9<double>(0, [1.1, 2.2]);

        f9<double>(0, 1, 2);
        f9<double>(0, new List<double> { 1, 2 });
    }

    void f10(int o, params List<int> args)
    {
        f10(0, 1, 2);
        f10(0, [1, 2]);
        f10(args: 1, o: 0);
        f10(0, args);
        f10(args: args, o: 0);
        f10(args: [1, 2], o: 0);
        short s1 = 1, s2 = 2;
        f10(0, s1, s2);
    }
}

class MyAttribute : Attribute
{
    public int x;
    public string y { get; set; }
    public MyAttribute(bool b) { }
}
