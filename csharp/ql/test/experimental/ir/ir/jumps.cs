using System;

class Jumps 
{
    public static void Main() 
    {
        for (int i = 1; i <= 10; i++) 
        {
            if (i == 3)
                continue;
            else if (i == 5)
                break;
            Console.WriteLine("BreakAndContinue");
        }

        for (int i = 0 ; i < 10 ; )
        {
            i++;
            continue;
        }

        int a = 0;
        while (true) 
        {
            a++;
            if (a == 5)
                continue;
            if (a == 10)
                break;
        } 

        for (int i = 1; i <= 10; i++) 
        {
            if (i == 5)
                goto done;
        }
        done:
        Console.WriteLine("Done");
    }
}
