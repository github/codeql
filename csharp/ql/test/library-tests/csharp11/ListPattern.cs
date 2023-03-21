using System.Collections.Generic;

class ListPattern
{
    public void M1(int[] x)
    {
        if (x is []) { }
        if (x is [1]) { }
        if (x is [_, 2]) { }
        if (x is [var y, 3, 4]) { }
        if (x is [5 or 6, _, 7]) { }
        if (x is [var a, .., 2]) { }
        if (x is [var b, .. { Length: 2 or 5 }, 2]) { }
    }

    public void M2(string[] x)
    {
        switch (x)
        {
            case []:
                break;
            case ["A"]:
                break;
            case [_, "B"]:
                break;
            case [var y, "C", "D"]:
                break;
            case ["E" or "F", _, "G"]:
                break;
            case [var a, .., "H"]:
                break;
            case [var b, .. var c, "I"]:
                break;
            default:
                break;
        }
    }
}