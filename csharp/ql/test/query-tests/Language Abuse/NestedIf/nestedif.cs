using System;

class NestedIf
{
    void fn()
    {
        // BAD:
        if (true) if (false) return;

        // BAD
        if (true) if (false) if (true) return;

        // BAD: using braces
        if (true)
        {
            {
                if (false)
                {
                }
            }
        }

        // GOOD: contains else part
        if (true)
        {
            if (true)
            {
            }
            else
            {
            }
        }

        // GOOD: contains else part
        if (true)
        {
            if (true)
            {
            }
        }
        else
        {
        }

        // GOOD: because of additional statements.
        if (true)
        {
            int x = 0;
            if (true)
            {
            }
        }

        // GOOD: because of additional statements.
        if (true)
        {
            if (true)
            {
            }
            int x = 0;
        }
    }

}
