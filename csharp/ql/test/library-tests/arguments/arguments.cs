using System;

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
    }

    void f4(params object[] args)
    {
        f4(new object[] { null }, null);
    }
}
