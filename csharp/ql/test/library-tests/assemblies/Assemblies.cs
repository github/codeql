using System;
using Assembly1;
using Locations;

namespace TestAssemblies
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.Out.WriteLine(Class1.d());
        }

        Locations.Test l = new Locations.Test();
    }
}
