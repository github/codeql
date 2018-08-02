using System;
using System.IO;

namespace UseOfSystemOutputStream.cs
{
    class Main
    {

        public void Foo(string s, TextWriter t)
        {

            Console.WriteLine("string: " + s);  // BAD

            t.WriteLine(s); // GOOD

            t = Console.Out; // BAD

            t.WriteLine(s); // GOOD

            Console.SetError(t); // GOOD

            t = Console.Error; // GOOD

        }

    }

}
