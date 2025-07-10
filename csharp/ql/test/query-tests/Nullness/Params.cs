using System;
using System.Collections.Generic;
using System.Linq;

public class Params
{
    public void M1(params string[] args)
    {
        var l = args.Length; // Good, true negative
    }

    public void M2(params string[] args)
    {
        var l = args.Length; // Good
    }

    public void M()
    {
        M1("a", "b", "c", null);
        M2(null);
    }
}