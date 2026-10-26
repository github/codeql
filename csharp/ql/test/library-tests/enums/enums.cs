using System;
using System.IO;
using System.Collections.Generic;

namespace Enums
{
    enum Color
    {

        Red, Green, Blue

    }

    internal enum LongColor : long
    {

        Red,
        Green,
        Blue

    }

    enum E : long { }

    enum ValueColor : uint
    {

        OneRed = 1,
        TwoGreen = 2,
        FourBlue = 4

    }

    enum SparseColor
    {

        Red,
        Green = 10,
        Blue,
        AnotherBlue = Blue + Red

    }

    class Test
    {

        static void Main()
        {
            Console.WriteLine(StringFromColor(SparseColor.Red));
            Console.WriteLine(StringFromColor(SparseColor.Green));
            Console.WriteLine(StringFromColor(SparseColor.Blue));
        }

        static string StringFromColor(SparseColor c)
        {
            switch (c)
            {
                case SparseColor.Red: return String.Format("Red = {0}", (int)c);
                case SparseColor.Green: return String.Format("Green = {0}", (int)c);
                case SparseColor.Blue: return String.Format("Blue = {0}", (int)c);
                default: return "Invalid color";
            }
        }
    }
}
