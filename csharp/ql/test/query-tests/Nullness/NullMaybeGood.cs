using System;

class Good
{
    void DoPrint(object o)
    {
        if (o != null)
            Console.WriteLine(o.ToString());
    }

    void M()
    {
        DoPrint("Hello");
        DoPrint(null);
    }
}
