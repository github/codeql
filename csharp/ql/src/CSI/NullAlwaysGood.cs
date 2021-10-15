using System;

namespace NullAlways
{
    class Good
    {
        void DoPrint(string s)
        {
            if (s != null && s.Length > 0)
                Console.WriteLine(s);
        }
    }
}
