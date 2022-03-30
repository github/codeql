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
            x0 += "" + i; // BAD
            x1 = x1 + i; // BAD
            var x2 = "";
            x2 += x1; // GOOD
        }
    }
}
