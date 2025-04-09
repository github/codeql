using System;

class FutileConditionalTest
{

    public void M(string s)
    {
        if (s.Length > 0) ; // $ Alert

        if (s.Length > 1)
        {
        } // $ Alert

        if (s.Length > 2) // GOOD: because of else-branch
        {
        }
        else
        {
            Console.WriteLine("hello");
        }

        if (s.Length > 3)
        {
        }
        else
        {
        } // $ Alert

        if (s.Length > 4)
        {
            // GOOD: Because of the comment.
        }
    }
}
