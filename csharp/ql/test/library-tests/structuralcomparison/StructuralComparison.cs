using System;

public class Class
{
    private readonly int x = 0;
    private readonly int y = 1;

    public int M0() => 0;
    public int M1(int a) => a;
    public int M2(int v1, int v2) => v1 + v2;


    public void M3()
    {
        var z1 = x + y;
        var z2 = x + y;
    }

    public void M4()
    {
        var z3 = M1(x);
        var z4 = M1(x);
        var z5 = M1(y);
        var z6 = M0();
        var z7 = M2(x, y) + M2(x, y);
        M2(x, y);
        M2(y, x);
        M2(y, x);
    }
}

public class BaseClass
{
    public int Field;
    public object Prop { get; set; }
}

public class DerivedClass : BaseClass
{
    public void M4()
    {
        var x1 = base.Field;
        var x2 = Field;
        var x3 = this.Field;
    }

    public void M5()
    {
        var y1 = base.Prop;
        var y2 = Prop;
        var y3 = this.Prop;
    }
}

