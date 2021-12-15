using System;

class T { }

class ParenthesizedPattern
{
    void M1(object o)
    {
        if (o is {} p1)
        {
        }

        if (o is ({} p2))
        {
        }
    }

    void M2(object o)
    {
        var r = o switch
        {
            1 => 1,
            (2) => 2,
            T t when t is {} => 3,
            (object o1) when o1 is ({}) => 4,
            (string _) => 5
        };
    }
}
