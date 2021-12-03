class ObjectComparison
{
    class AlwaysEqual
    {
        public static bool operator ==(AlwaysEqual a, AlwaysEqual b)
        {
            return true;
        }
        public static bool operator !=(AlwaysEqual a, AlwaysEqual b)
        {
            return false;
        }
    }
    public static void Main(string[] args)
    {
        object a = new AlwaysEqual();
        AlwaysEqual b = new AlwaysEqual();
        Console.WriteLine(a == b);
    }
}
