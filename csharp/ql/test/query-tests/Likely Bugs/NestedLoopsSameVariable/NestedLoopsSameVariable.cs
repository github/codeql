using System;

class NestedLoopsSameVariable
{
    static void Main(string[] args)
    {
        for (int i = 0; i < 2; i++)
        {
            for (int j = 0; j < 2; i++)
            {
                Console.WriteLine(i + " " + j);
            }
        }
    }
}
