class PointlessForwardingMethod
{
    public static void Print(string firstName, string lastName)
    {
        Print(firstName + " " + lastName);
    }

    public static void Print(string fullName)
    {
        Console.WriteLine("Pointless forwarding methods are bad, " + fullName + "...");
    }

    public static void Main(string[] args)
    {
        Print("John", "Doe");
    }
}
