class AbstractToConcreteCollection
{
    public static void Main(string[] args)
    {
        ICollection<String> foo = new List<String>();
        foo.Add("hello");
        foo.Add("world");
        List<String> bar = (List<String>)foo; // BAD
    }
}
