using System;

class Good
{
    class Details
    {
        public string Name { get; private set; }
        public string Address { get; private set; }
        public string Tel { get; private set; }

        public Details(string name, string address, string tel)
        {
            Name = name;
            Address = address;
            Tel = tel;
        }
    }

    private static Details PopulateDetails()
    {
        return new Details("Foo", "23 Bar Street", "01234 567890");
    }

    private static void PrintDetails(Details details)
    {
        Console.WriteLine("Name: " + details.Name);
        Console.WriteLine("Address: " + details.Address);
        Console.WriteLine("Tel.: " + details.Tel);
    }

    static void Main(string[] args)
    {
        PrintDetails(PopulateDetails());
    }
}
