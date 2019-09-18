using System.Collections.Generic;

class Program
{
    static object mutex = new object();
    static object obj1;
    static volatile object obj2;
    object obj3;
    bool cond1;
    volatile bool cond2;
    Coord struct1, struct2;
    (int,int) pair1;

    void Fn()
    {
        // BAD
        if (obj1 == null)
        {
            lock (mutex)
            {
                if (obj1 == null)
                {
                    obj1 = null;
                }
            }
        }

        // BAD
        if (obj1 == null)
            lock (mutex)
                if (obj1 == null)
                    obj1 = null;

        // GOOD: A value-type
        if (cond1)
            lock (mutex)
                if (cond1)
                    cond1 = false;

        // GOOD: volatile
        if (obj2 == null)
        {
            lock (mutex)
            {
                if (obj2 == null)
                {
                    obj2 = null;
                }
            }
        }

        // GOOD: volatile
        if (cond2)
            lock (mutex)
                if (cond2) { cond2 = false; }


        // GOOD: not a double-checked lock
        if (null == obj1)
        {
            lock (mutex)
            {
                if (null == obj2)
                    obj1 = null;
            }
        }

        // BAD (false-positive): not a double-checked lock
        // as the condition is not the same.
        if (null == obj1)
        {
            lock (mutex)
            {
                if (obj1 == null)
                    obj1 = null;
            }
        }

        // BAD
        if (null == obj1)
        {
            lock (mutex)
            {
                int x;
                if (null == obj1)
                    obj1 = null;
            }
        }

        // GOOD: not a field
        object a = null;
        if (a == null)
            lock (mutex)
                if (a == null)
                    a = new object();

        // BAD: only obj1 is flagged.
        if (obj1 == null && obj2 == null)
        {
            lock (mutex)
            {
                if (obj1 == null && obj2 == null)
                {
                    obj1 = null;
                }
            }
        }

        // BAD: both obj1 and obj3 are flagged.
        if (obj1 == null && obj3 == null)
        {
            lock (mutex)
            {
                if (obj1 == null && obj3 == null)
                {
                    obj1 = null;
                    obj3 = null;
                }
            }
        }

        // GOOD: Locking a struct
        if (struct1 == struct2)
        {
            lock(mutex)
            {
                if (struct1 == struct2)
                {
                    struct1 = new Coord();
                }
            }
        }

        // BAD: Field x should be volatile
        if (struct1.x is null)
            lock (mutex)
                if(struct1.x is null)
                    struct1.x = 3;

        // GOOD: Tuples are structs so cannot be volatile.
        if(pair1 == (1,2))
        {
            lock(mutex)
            {
                if(pair1 == (1,2))
                    pair1 = (2,3);
            }
        }
    }
}

struct Coord
{
    public object x, y;

    public static bool operator==(Coord c1, Coord c2) => c1.x==c2.x && c1.y == c2.y;
    public static bool operator!=(Coord c1, Coord c2) => !(c1==c2);
}

// semmle-extractor-options: -langversion:latest
