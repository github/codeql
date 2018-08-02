class ImpossibleArrayCast
{
    static void Main(string[] args)
    {
        // This will result in an InvalidCastException.
        String[] strs = (String[])new Object[] { "hello", "world" };
    }
}
