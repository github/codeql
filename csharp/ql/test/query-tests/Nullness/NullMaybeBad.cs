using System;

namespace NullMaybe
{
    class Bad
    {
        void DoPrint(object o)
        {
            Console.WriteLine(o.ToString());
        }

        void M()
        {
            DoPrint("Hello");
            DoPrint(null);
        }
    }
}
