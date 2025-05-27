using System;

namespace NullAlways
{
    class Bad
    {
        void DoPrint(string s)
        {
            if (s != null || s.Length > 0) // $ Alert[cs/dereferenced-value-is-always-null]
                Console.WriteLine(s);
        }
    }
}
