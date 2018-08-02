using System;

class ChainedIs
{
    public void M(object x)
    {
        if (x is A)
        {
        }
        else if (x is B)
        {
        }
        else if (x is C)
        {
        }
        else if (x is D)
        {
        }
        else if (x is E)
        {
        } // GOOD

        if (x is A)
        {
        }
        else if (x is B)
        {
        }
        else if (x is C)
        {
        }
        else if (x is D)
        {
        }
        else if (x is E)
        {
        }
        else if (x is int)
        {
        }
        else if (x is int[])
        {
        }
        else if (x is Tuple<int>)
        {
        } // GOOD

        if (x is A)
        {
        }
        else if (x is B)
        {
        }
        else if (x is C)
        {
        }
        else if (x is D)
        {
        }
        else if (x is E)
        {
        }
        else if (x is F<int>)
        {
        } // BAD
    }

    class A { }
    class B { }
    class C { }
    class D { }
    class E { }
    class F<T> { }
}
