using System;
using System.Collections.Generic;

class Test
{
    static void Main(string[] args)
    {
        var dict = new Dictionary<int, int>();
        int x;

        // GOOD: Assignment
        if (!dict.ContainsKey(1)) dict[1] = 2;
        if (dict.ContainsKey(1)) dict[1] = 2;

        // GOOD: TryGetValue
        dict.TryGetValue(2, out x);

        // These are BAD
        if (dict.ContainsKey(1)) x = dict[1];
        if (dict.ContainsKey(1) && dict[1] == 2) ;
        if (!dict.ContainsKey(1) && dict[1] == 2) ;
        if (!dict.ContainsKey(1) || dict[1] == 2) ;
        if (dict.ContainsKey(1) || dict[1] == 2) ;

        if (dict.ContainsKey(1))
            x = dict[1];
        else
            x = dict[1];
        if (!dict.ContainsKey(1))
            x = dict[1];
        else
            x = dict[1];

        x = dict.ContainsKey(1) ? dict[1] : dict[1];
        x = !dict.ContainsKey(1) ? dict[1] : dict[1];
        x = true && !dict.ContainsKey(1) ? dict[1] : dict[1];

        // GOOD: Different index
        if (dict.ContainsKey(0)) x = dict[1];

        // GOOD: Different collection
        var dict2 = dict;
        if (dict2.ContainsKey(0)) x = dict[0];
    }
}
