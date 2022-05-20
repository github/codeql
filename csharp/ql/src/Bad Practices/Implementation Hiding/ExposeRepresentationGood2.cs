using System;

class Good2
{
    class Range
    {
        private int[] rarray = new int[2];

        public Range(int min, int max)
        {
            if (min <= max)
            {
                rarray[0] = min;
                rarray[1] = max;
            }
        }

        public int[] Get() => (int[])rarray.Clone();
    }

    public static void Main(string[] args)
    {
        Range a = new Range(1, 10);
        int[] a_range = a.Get();
        a_range[0] = 500;
        Console.WriteLine("Min: " + a.Get()[0] + " Max: " + a.Get()[1]);
        // prints "Min: 1 Max: 10"
    }
}
