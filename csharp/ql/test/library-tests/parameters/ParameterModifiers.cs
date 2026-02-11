using System;
using System.Collections.Generic;

public class ParameterModifiers
{
    public void M1(object p1) { }
    public void M2(in object p2) { }

    public void M3(out object p3)
    {
        p3 = new object();
    }

    public void M4(ref object p4) { }

    public void M5(params object[] p5) { }

    public void M6(ref readonly object p6) { }

    public void M7(params IEnumerable<object> p7) { }
}
