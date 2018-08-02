using System;

class Patterns
{
    void Test()
    {
        object o = null;
        if (o is int i1)
        {
            Console.WriteLine($"int {i1}");
        }
        else if (o is string s1)
        {
            Console.WriteLine($"string {s1}");
        }
        else if (o is var v1)
        {
        }

        switch (o)
        {
            case "xyz":
                break;
            case int i2 when i2 > 0:
                Console.WriteLine($"positive {i2}");
                break;
            case int i3:
                Console.WriteLine($"int {i3}");
                break;
            case string s2:
                Console.WriteLine($"string {s2}");
                break;
            case var v2:
                break;
            default:
                Console.WriteLine("Something else");
                break;
        }

        switch (o)
        {
        }
    }
}
