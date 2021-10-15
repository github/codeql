using System;

class FixedRandom
{
    public static void Main(string[] args)
    {
        Random rng = new Random();
        for (int i = 0; i < 10; ++i)
            Console.Out.WriteLine(rng.Next());

        /* Typical output:
                1727678897
                1302766072
                1862602754
                306287288
                1158341977
                1381161104
                1200326172
                1743307709
                611422858
                1455448871
        */
    }
}
