using System;

using TupleType1 = (int, object);
using TupleType2 = (int, string);
using TupleType3 = (int, object);
using Point = (int x, int y);

public class TupleMethods
{
    public void M1(TupleType1 t)
    {
        var x = t.Item1;
        var y = t.Item2;
    }

    public void M2(TupleType2 t)
    {
        var x = t.Item1;
        var y = t.Item2;
        M1(t);
    }

    public void M3(Point p)
    {
        var x = p.x;
        var y = p.y;
    }

    public void M4(TupleType3 t) { }
}
