using System;

class PatternMatchSpan
{

    public void M1(ReadOnlySpan<char> x1)
    {
        if (x1 is "ABC") { }
    }

    public void M2(Span<char> x2)
    {
        switch (x2)
        {
            case "DEF": { break; }
            default: { break; }
        }
    }
}