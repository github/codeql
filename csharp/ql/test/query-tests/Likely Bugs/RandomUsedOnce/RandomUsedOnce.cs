using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

class RandomTest
{
    void f()
    {
        new Random().Next();  // BAD

        byte[] buffer = new byte[10];
        new Random().NextBytes(buffer); // BAD

        new Random().NextDouble();  // BAD
        new Random().Next(10);      // BAD
        new Random().Next(10, 20);   // BAD

        new Random().Equals(null);  // GOOD
    }
}
