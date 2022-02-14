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

public class BaseClass
{
    public int Field;
    public object Prop { get; set; }
}

public class DerivedClass : BaseClass
{
    public void M3()
    {
        var x1 = base.Field;
        var x2 = Field;
        var x3 = this.Field;
    }

    public void M4()
    {
        var y1 = base.Prop;
        var y2 = Prop;
        var y3 = this.Prop;
    }
}

