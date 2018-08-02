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
    public int[] get()
    {
        return (int[])rarray.Clone();
    }
}
class Program
{
    public static void Main(string[] args)
    {
        Range a = new Range(1, 10);
        int[] a_range = a.get();
        a_range[0] = 500;
        Console.WriteLine("Min: " + a.get()[0] + " Max: " + a.get()[1]);
        // prints "Min: 1 Max: 10"
    }
}
