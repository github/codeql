using System;
using System.Linq;
using System.Collections.Generic;

class MissedWhereOpportunity
{
    public void M1(List<int> lst)
    {
        // BAD: Can be replaced with lst.Where(e => e % 2 == 0)
        foreach (int i in lst)
        {
            if (i % 2 != 0)
                continue;
            Console.WriteLine(i);
            Console.WriteLine((i / 2));
        }

        // BAD: Can be replaced with lst.Where(e => e % 2 == 0)
        foreach (int i in lst)
        {
            if (i % 2 == 0)
            {
                Console.WriteLine(i);
                Console.WriteLine((i / 2));
            }
        }
    }

    public void M2(NonEnumerableClass nec)
    {
        // GOOD: Linq can't be used here.
        foreach (int i in nec)
        {
            if (i % 2 == 0)
            {
                Console.WriteLine(i);
                Console.WriteLine((i / 2));
            }
        }
    }

    public void M3(int[] arr)
    {
        // BAD: Can be replaced with arr.Where(e => e % 2 == 0)
        foreach (var n in arr)
        {
            if (n % 2 == 0)
            {
                Console.WriteLine(n);
                Console.WriteLine((n / 2));
            }
        }
    }

    public void M4(Array arr)
    {
        // GOOD: Linq can't be used here.
        foreach (var element in arr)
        {
            if (element.GetHashCode() % 2 == 0)
            {
                Console.WriteLine(element);
            }
        }
    }

    public void M5(IEnumerable<int> elements)
    {
        // BAD: Can be replaced with elements.Where(e => e.GetHashCode() % 2 == 0)
        foreach (var element in elements)
        {
            if (element.GetHashCode() % 2 == 0)
            {
                Console.WriteLine(element);
            }
        }
    }

    public class NonEnumerableClass
    {
        public IEnumerator<int> GetEnumerator() => throw null;
    }
}
