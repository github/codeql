using System;

class Discards
{
    (int, double) f(out bool x)
    {
        x = false;
        return (0, 0.0);
    }

    void Out()
    {
        _ = f(out _);
    }

    void Tuples()
    {
        (_, _) = f(out _);
        (var x, _) = f(out _);
        (_, var y) = f(out var z);
    }

    void Foreach(string[] args)
    {
        foreach (var _ in args)
        {
        }
    }

    void Switch(object o)
    {
        switch (o)
        {
            case int _: return;
        }
    }
}
