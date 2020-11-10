using System;

class PostDominance
{
    void M1(string s)
    {
        Console.WriteLine(s); // post-dominates entry
    }

    void M2(string s)
    {
        if (s is null)
            return;
        Console.WriteLine(s); // does not post-dominate entry
    }

    void M3(string s)
    {
        if (s is null)
            throw new ArgumentNullException(nameof(s));
        Console.WriteLine(s); // post-dominates entry
    }
}
