using System;

class ExposeRepresentation
{
    class Range
    {
        private int[] rarray = new int[2];
        public void Set(int[] a) { rarray = a; }
    }

    public static void Main(string[] args)
    {
        var a = new int[] { 0, 1 };
        var r = new Range();
        r.Set(a); // BAD
        a[0] = 500;
    }
}
