using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

namespace ConsoleApplication2
{
    class Program
    {

        static void Main(string[] args)
        {
            int a = 2;

            // BAD
            if (a % 2 == 1)
                Console.Out.WriteLine("a is odd");
            if (a % 2 != 1)
                Console.Out.WriteLine("a is even");
            if (a % 2 > 0)
                Console.Out.WriteLine("a is odd");
            if ((a % 2) > 0)
                Console.Out.WriteLine("a is odd");

            // GOOD
            if (a % 2 == 0)
                Console.Out.WriteLine("a is even");
            if (a % 2 != 0)
                Console.Out.WriteLine("a is odd");
            if (a % 2 > 1)
                Console.Out.WriteLine("a is very odd");
            if (args.Length % 2 == 1)
                Console.Out.WriteLine("args.Length is odd");
            if (args.Count() % 2 == 1)
                Console.Out.WriteLine("args.Count() is odd");
        }
    }
}

// semmle-extractor-options: /r:System.Runtime.Extensions.dll /r:System.Linq.dll
