using System;

public record Point(int X, int Y);
public record Line(Point P1, Point P2);
public record Wrap(Line L);

public class PropertyPatterns
{
    private static Line l = new Line(new Point(1, 2), new Point(3, 6));
    private static Wrap w = new Wrap(l);

    public void M1()
    {
        if (l is { P1: { X: 1 } })
        {
        }

        if (l is { P1.X: 2 })
        {
        }
    }

    public void M2()
    {
        if (w is { L: { P2: { Y: 3 } } })
        {
        }

        if (w is { L.P2.Y: 4 })
        {
        }
    }

    public void M3()
    {
        if (w is { L: { P2.Y: 5 } })
        {
        }

        if (w is { L.P2: { Y: 6 } })
        {
        }
    }

    public void M4()
    {
        if (l is { P1: { X: 7 }, P1: { Y: 8 } })
        {
        }

        if (l is { P1.X: 9, P1.Y: 10 })
        {
        }
    }
}

