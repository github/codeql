using System;

class BadRandom
{
    public static void Main(string[] args)
    {
        for (int i = 0; i < 10; ++i)
            Console.Out.WriteLine(new Random().Next());

        /* Typical output:
                1003050238
                1003050238
                1003050238
                1003050238
                1003050238
                1003050238
                1003050238
                1003050238
                1003050238
                1003050238
        */
    }
}
