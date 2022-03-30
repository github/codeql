using System;

class WriteLineArrayTest
{
    static void Main(string[] args)
    {
        Console.Write(args);    // BAD
        Console.WriteLine(args);  // BAD

        Console.Write("{0}{1}", 1, args);   // BAD
        Console.WriteLine("{0}{1}", 1, args); // BAD

        Console.WriteLine("{0}{1}", args);  // GOOD
        Console.Write("{0}{1}", args);    // GOOD

        Console.Out.Write(args);    // GOOD
        Console.Out.WriteLine(args);  // GOOD
    }
}
