using System;

class Test
{
    void SameCondition()
    {
        for (int i=0; i<10; ++i)
        {
            // GOOD: Same condition
            for (; i<10; ++i)
            {
                Console.WriteLine(i);
            }
        }
    }

    void DifferentCondition1()
    {
        for (int i=0; i<10; ++i)
        {
            // BAD: considered to be a different condition
            for (; 10>i; ++i)
            {
                Console.WriteLine(i);
            }
        }
    }

    void DifferentCondition2()
    {
        for (int i=0; i<10; ++i)
        {
            // BAD: different condition
            for (; i<9; ++i)
            {
                Console.WriteLine(i);
            }
        }
    }

    void DifferentConditions3()
    {
        for (int i=0; i<10; ++i)
        {
            // BAD: different condition
            for (; i<=10; ++i)
            {
                Console.WriteLine(i);
            }
        }
    }

    void UseAfterInnerLoop()
    {
        for (int i=0; i<10; ++i)
        {
            for (; i<10; ++i)
            {
            }

            // BAD: i is not guarded
            Console.WriteLine(i);
        }
    }

    void GuardedAfterInnerLoop()
    {
        for (int i=0; i<10; ++i)
        {

            // GOOD: same condition
            for (; i<10; ++i)
            {
            }

            if (10 > i)
            {
                // GOOD: i is guarded
                Console.WriteLine(i);
            }
        }
    }

    void GuardedByContinue()
    {
        for (int i=0; i<10; ++i)
        {

            // GOOD: same condition
            for (; i<10; ++i)
            {
            }

            if (10 <= i) continue;

            // GOOD: i is guarded
            Console.WriteLine(i);
        }
    }
}
