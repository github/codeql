using System;

class Program
{
    string x0;

    public Program()
    {
        x0 = "";
        var x1 = "";
        for (var i = 0; i < 1000; i++)
        {
            x0 += "" + i; // $ Alert // BAD
            x1 = x1 + i; // $ Alert // BAD
            var x2 = "";
            x2 += x1; // GOOD
        }
    }
}
