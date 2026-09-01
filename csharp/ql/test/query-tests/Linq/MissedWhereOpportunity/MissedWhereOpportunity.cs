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
        } // $ Alert

        // BAD: Can be replaced with lst.Where(e => e % 2 == 0)
        foreach (int i in lst)
        {
            if (i % 2 == 0)
            {
                Console.WriteLine(i);
                Console.WriteLine((i / 2));
            }
        } // $ Alert
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
        } // $ Alert
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
        } // $ Alert
    }

    public int M6(IEnumerable<int> elements)
    {
        // GOOD: The filtered case returns from the method instead of continuing the loop.
        foreach (var element in elements)
        {
            if (element.GetHashCode() % 2 == 0)
            {
                return element;
            }
        }

        return 0;
    }

    public IEnumerable<int> M7(IEnumerable<int> elements)
    {
        // GOOD: The filtered case exits the iterator instead of continuing the loop.
        foreach (var element in elements)
        {
            if (element.GetHashCode() % 2 == 0)
            {
                yield break;
            }
        }
    }

    public void M8(IEnumerable<int> elements)
    {
        // GOOD: The filtered case throws instead of continuing the loop.
        foreach (var element in elements)
        {
            if (element.GetHashCode() % 2 == 0)
            {
                throw new InvalidOperationException();
            }
        }
    }

    public IEnumerable<int> M9(IEnumerable<int> elements)
    {
        // BAD: A yield return does not exit the iterator, so the loop still filters yielded values.
        foreach (var element in elements)
        {
            if (element.GetHashCode() % 2 == 0)
            {
                yield return element;
            }
        } // $ Alert
    }

    public int M10(IEnumerable<int> elements)
    {
        // GOOD: The filtered case ends with a return from the method instead of continuing the loop.
        foreach (var element in elements)
        {
            if (element.GetHashCode() % 2 == 0)
            {
                Console.WriteLine(element);
                return element;
            }
        }

        return 0;
    }

    public int M11(IEnumerable<int> elements)
    {
        // GOOD: Both nested filtered cases return from the method instead of continuing the loop.
        foreach (var element in elements)
        {
            if (element.GetHashCode() % 2 == 0)
            {
                if (element > 10)
                {
                    return element;
                }
                else
                {
                    return 10;
                }
            }
        }

        return 0;
    }

    public class NonEnumerableClass
    {
        public IEnumerator<int> GetEnumerator() => throw null;
    }
}
