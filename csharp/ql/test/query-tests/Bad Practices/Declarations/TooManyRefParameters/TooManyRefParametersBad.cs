using System;

class Bad
{
    private static void PopulateDetails(ref string name, ref string address, ref string tel)
    {
        name = "Foo";
        address = "23 Bar Street";
        tel = "01234 567890";
    }

    private static void PrintDetails(string name, string address, string tel)
    {
        Console.WriteLine("Name: " + name);
        Console.WriteLine("Address: " + address);
        Console.WriteLine("Tel.: " + tel);
    }

    static void Main(string[] args)
    {
        string name = null, address = null, tel = null;
        PopulateDetails(ref name, ref address, ref tel);
        PrintDetails(name, address, tel);
    }
}
