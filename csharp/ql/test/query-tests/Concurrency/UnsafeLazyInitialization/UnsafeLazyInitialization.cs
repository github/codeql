
class Program
{
    static object mutex = new object();
    static object obj1;
    static volatile object obj2;
    static bool cond1;
    static volatile bool cond2;

    static void Main(string[] args)
    {
        // BAD
        if (obj1 == null)
        {
            lock (mutex)
            {
                if (obj1 == null)
                {
                    // ...
                }
            }
        }

        // BAD
        if (obj1 == null)
            lock (mutex)
                if (obj1 == null)
                {
                    // ...
                }

        // BAD
        if (cond1) lock (mutex) if (cond1) { }

        // GOOD: volatile
        if (obj2 == null)
        {
            lock (mutex)
            {
                if (obj2 == null)
                {
                }
            }
        }

        // GOOD: volatile
        if (cond2) lock (mutex) if (cond2) { }

        // BAD: FALSE NEGATIVE - not recognized as double-checked lock
        if (null == obj1)
        {
            lock (mutex)
            {
                if (obj2 == null) { }
            }
        }

        // BAD: FALSE NEGATIVE - not recognized as double-checked lock
        if (null == obj1)
        {
            lock (mutex)
            {
                int x;
                if (obj2 == null) { }
            }
        }

        // GOOD: not a field
        object a = null;
        if (a == null) lock (mutex) if (a == null) { }
    }
}
