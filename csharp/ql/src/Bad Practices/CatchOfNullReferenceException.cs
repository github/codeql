class CatchOfNullReferenceException
{
    public static Person findPerson(string name)
    {
        // ...
    }

    public static void Main(string[] args)
    {
        Console.WriteLine("Enter name of person:");
        Person p = findPerson(Console.ReadLine());
        try
        {
            Console.WriteLine("Person is {0:D} years old", p.getAge());
        }
        catch (NullReferenceException e)
        {
            Console.WriteLine("Person not found.");
        }
    }
}
