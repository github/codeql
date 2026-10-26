using System;
using System.Runtime.InteropServices;
using System.Runtime.CompilerServices;

public class LambdaParameters
{
    public void M1()
    {
        var l1 = (int x, int y = 1) => x + y;
        var l2 = (object? o = default) => o;
        var l3 = (int x, int y = 1, int z = 2) => x + y + z;
        var l4 = ([Optional, DefaultParameterValue(7)] int x) => x;
        var l5 = ([Optional, DateTimeConstant(14L)] DateTime x) => x;
    }
}
