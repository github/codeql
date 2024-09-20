using System;

class LambdaArgumentsTest
{
    void M1()
    {
        var l1 = (int x) => x + 1;
        l1(1);

        var l2 = (int x, int y = 1) => x + y;
        l2(2, 3);
        l2(4);
        l2(5, 6);

        var l3 = (params int[] x) => x.Length;
        l3();
        l3(7, 8, 9);
    }

    delegate int MyDelegate(int x, int y);

    void M2()
    {
        MyDelegate sum = (int x, int y) => x + y;
        sum(y: 4, x: 5);
    }
}

