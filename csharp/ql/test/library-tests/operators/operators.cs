using System;
using System.IO;
using System.Collections.Generic;

namespace Operators
{
    public class IntVector
    {

        public IntVector(int length) { }

        public int Length { get { return 4; } }

        public int this[int index] { get { return 0; } set { } }

        public static IntVector operator ++(IntVector iv)
        {
            IntVector temp = new IntVector(iv.Length);
            for (int i = 0; i < iv.Length; i++)
                temp[i] = iv[i] + 1;
            return temp;
        }

    }

    class TestUnaryOperator
    {

        void Main()
        {
            IntVector iv1 = new IntVector(4); // vector of 4 x 0
            IntVector iv2;
            iv2 = iv1++;  // iv2 contains 4 x 0, iv1 contains 4 x 1
            iv2 = ++iv1;  // iv2 contains 4 x 2, iv1 contains 4 x 2
        }

    }

    public struct Digit
    {

        byte value;

        public Digit(byte value)
        {
            if (value < 0 || value > 9)
                throw new ArgumentException();
            this.value = value;
        }

        public static implicit operator byte(Digit d)
        {
            return d.value;
        }

        public static explicit operator Digit(byte b)
        {
            return new Digit(b);
        }

    }

    class TestConversionOperator
    {

        void Main()
        {
            Digit d = (Digit)8;
            byte b = d;
        }

    }

}
