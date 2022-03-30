using System;
using System.Collections;

class Point
{
    private int x;
    private int y;

    public Point(int x, int y)
    {
        this.x = x;
        this.y = y;
    }

    public override bool Equals(Object other)
    {
        Point point = other as Point;
        if (point == null)
        {
            return false;
        }
        return this.x == point.x && this.y == point.y;
    }

    public static void Main(string[] args)
    {
        Hashtable hashtable = new Hashtable();
        hashtable[new Point(5, 4)] = "A point"; // BAD
        // Point overrides the Equals method but not GetHashCode.
        // As such it is probably not useful to use one as the key for a Hashtable.
        Console.WriteLine(hashtable[new Point(5, 4)]);
    }
}
