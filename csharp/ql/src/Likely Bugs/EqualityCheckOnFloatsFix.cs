class EqualityCheckOnFloatsFix
{
    public static void Main(string[] args)
    {
        const double EPSILON = 0.001;
        Console.WriteLine(Math.Abs((0.1 + 0.2) - 0.3) < EPSILON);
    }
}
