using System;

class Bad
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

        public int[] Get() => rarray;
    }

    public static void Main(string[] args)
    {
        var r = new Range(1, 10);
        var r_range = r.Get();
        r_range[0] = 500;
        Console.WriteLine("Min: " + r.Get()[0] + " Max: " + r.Get()[1]);
        // prints "Min: 500 Max: 10"
    }
}
