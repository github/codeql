class CatchOfNullReferenceExceptionFix
{
    public static Person findPerson(string name)
    {
        // ...
    }

    public static void Main(string[] args)
    {
        Console.WriteLine("Enter name of person:");
        Person p = findPerson(Console.ReadLine());
        if (p != null)
        {
            Console.WriteLine("Person is {0:D} years old", p.getAge());
        }
        else
        {
            Console.WriteLine("Person not found.");
        }
    }
}
