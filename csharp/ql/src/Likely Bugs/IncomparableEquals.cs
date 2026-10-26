using System.Collections;

class IncomparableEquals
{
    public static void Main(string[] args)
    {
        ArrayList apple = new ArrayList();
        String orange = "foo";
        Console.WriteLine(apple.Equals(orange)); // BAD
        Console.WriteLine(orange.Equals(apple)); // BAD
    }
}
