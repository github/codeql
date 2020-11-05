using System;
using System.Collections.Generic;
using System.Linq;

public class TargetType
{
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
}