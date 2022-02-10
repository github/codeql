using System;

public class Class
{
    public int MUnit() => 0;

    public int M0(int a) => a;

    public void M1()
    {
        var x = 0;
        var y = 1;
        var z1 = x + y;
        var z2 = x + y;
        var z3 = M0(x);
        var z4 = M0(x);
        var z5 = MUnit();
    }
}