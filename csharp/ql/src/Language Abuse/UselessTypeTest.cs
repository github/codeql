class UselessTypeTest
{
    class Super { }
    class Sub : Super { }

    static void Main(string[] args)
    {
        Sub sub = new Sub();
        if (sub is Super)
        {
            Console.WriteLine("Surprise! sub is a Super!");
        }
    }
}
