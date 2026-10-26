using System;

public class TypePattern
{
    object M1(object o1, object o2)
    {
        var t = (o1, o2);
        if (t is (int, string)) {}
        return o1 switch
        {
            int => 1,
            double d => d,
            System.String => 3,
            System.Object o => o
        };
    }
}
