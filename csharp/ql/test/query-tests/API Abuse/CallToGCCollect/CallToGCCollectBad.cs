using System;

class Bad
{
    void M()
    {
        GC.Collect();
    }
}
