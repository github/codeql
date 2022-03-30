using System;
using System.Collections.Generic;
using System.Linq;

public class TargetType
{
    public void M2()
    {
        var rand = new Random();
        var condition = rand.NextDouble() > 0.5;

        int? x0 = 12;
        x0 = 13;
        int? x1 = null;

        int? x2 = condition
            ? 12
            : null;

        int? x3 = condition
            ? (int?)12
            : null;

        int? x4 = condition
            ? 12
            : (int?)null;

        IEnumerable<int> xs0 = new List<int>() { 0, 1 };
        IEnumerable<int> xs1 = new int[] { 2, 3 };

        IEnumerable<int> xs2 = x2 is null
            ? new List<int>() { 0, 1 }
            : new int[] { 2, 3 };

        int? c = condition
            ? new TargetType()
            : 12;
    }

    public static implicit operator int(TargetType d) => 0;
}
