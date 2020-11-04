using System;
using System.Collections.Generic;
using System.Linq;

public class TargetType
{
    public int Prop1 { get; set; }
    private List<TargetType> l = new();

    public TargetType M1(TargetType t)
    {
        this.M1(new());
        return new() { Prop1 = 1 };
    }

    public void M2()
    {
        var rand = new Random();
        var condition = rand.NextDouble() > 0.5;

        int? x = condition
            ? 12
            : null;

        IEnumerable<int> xs = x is null
            ? new List<int>() { 0, 1 }
            : new int[] { 2, 3 };
    }

    delegate void D(int x);

    void M(int x) { }

    D GetM() { return new(M); }
}
