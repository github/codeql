using System;

class NullCoalescingAssignment
{
    void NullCoalescing()
    {
        object o = null;
        o ??= this;
    }
}
