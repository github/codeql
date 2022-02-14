using System;

public class Class
{
    public int MUnit() => 0;

    public int M0(int a) => a;
    public int M1(int v1, int v2) => v1 + v2;


    public void M2()
    {
        var x = 0;
        var y = 1;
        var z1 = x + y;
        var z2 = x + y;
        var z3 = M0(x);
        var z4 = M0(x);
        var z5 = M0(y);
        var z6 = MUnit();
        var z7 = M1(x, y) + M1(x, y);
        M1(x, y);
        M1(x, y);
    }
}