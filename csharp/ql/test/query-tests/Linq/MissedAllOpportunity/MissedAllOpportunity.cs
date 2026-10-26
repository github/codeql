using System;
using System.Linq;
using System.Collections.Generic;

class MissedAllOpportunity
{
    public void M1(List<int> lst)
    {
        // BAD: Can be replaced with lst.All(e => e % 2 == 0)
        var allEven = true;
        foreach (int i in lst)
        {
            if (i % 2 != 0)
            {
                allEven = false;
                break;
            }
        } // $ Alert
    }

    public void M2(NonEnumerableClass nec)
    {
        // GOOD: Linq can't be used here.
        var allEven = true;
        foreach (int i in nec)
        {
            if (i % 2 != 0)
            {
                allEven = false;
                break;
            }
        }
    }

    public void M3(List<int> lst, ref int x)
    {
        // GOOD: Linq can't be used here because the condition uses a ref parameter.
        var allEven = true;
        foreach (int i in lst)
        {
            if (i % 2 != x)
            {
                allEven = false;
                break;
            }
        }
    }

    public class NonEnumerableClass
    {
        public IEnumerator<int> GetEnumerator() => throw null;
    }
}
