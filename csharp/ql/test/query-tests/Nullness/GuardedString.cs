using System;

class GuardedStringTest
{
    void Fn(bool b)
    {
        string s = b ? null : ""; // $ Source[cs/dereferenced-value-may-be-null]

        if (!string.IsNullOrEmpty(s))
        {
            Console.WriteLine(s.Length);
        }

        if (!string.IsNullOrWhiteSpace(s))
        {
            Console.WriteLine(s.Length);
        }

        if (s?.Length == 0)
            Console.WriteLine(s.Length); // GOOD

        if (s?.Length > 0)
            Console.WriteLine(s.Length); // GOOD

        if (s?.Length >= 0)
            Console.WriteLine(s.Length); // GOOD

        if (s?.Length < 10)
            Console.WriteLine(s.Length); // GOOD

        if (s?.Length <= 10)
            Console.WriteLine(s.Length); // GOOD

        if (s?.Length != 0)
            Console.WriteLine(s.Length); // $ Alert[cs/dereferenced-value-may-be-null]
        else
            Console.WriteLine(s.Length); // GOOD
    }
}
