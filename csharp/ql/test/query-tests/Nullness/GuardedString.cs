using System;

class GuardedStringTest
{
    void Fn()
    {
        string s = null;

        if (!string.IsNullOrEmpty(s))
        {
            Console.WriteLine(s.Length);
        }

        if (!string.IsNullOrWhiteSpace(s))
        {
            Console.WriteLine(s.Length);
        }

        if (s?.Length == 0)
            Console.WriteLine(s.Length); // null guarded

        if (s?.Length > 0)
            Console.WriteLine(s.Length); // null guarded

        if (s?.Length >= 0)
            Console.WriteLine(s.Length); // null guarded

        if (s?.Length < 10)
            Console.WriteLine(s.Length); // null guarded

        if (s?.Length <= 10)
            Console.WriteLine(s.Length); // null guarded

        if (s?.Length != 0)
            Console.WriteLine(s.Length); // not null guarded
        else
            Console.WriteLine(s.Length); // null guarded
    }
}
