class PointlessForwardingMethodFix
{
    public static void Print(string firstName, string lastName)
    {
        string fullName = firstName + " " + lastName;
        Console.WriteLine("Pointless forwarding methods are bad, " + fullName + "...");
    }

    public static void Main(string[] args)
    {
        Print("John", "Doe");
    }
}
