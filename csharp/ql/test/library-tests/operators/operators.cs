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

        public void operator +=(IntVector n)
        {
            if (n.Length != Length)
                throw new ArgumentException();
            for (int i = 0; i < Length; i++)
                this[i] += n[i];
        }

        public void operator checked +=(IntVector n) { }

        public void operator checked -=(IntVector n) { }
        public void operator -=(IntVector n) { }

        public void operator checked *=(IntVector n) { }
        public void operator *=(IntVector n) { }

        public void operator checked /=(IntVector n) { }
        public void operator /=(IntVector n) { }

        public void operator %=(IntVector n) { }
        public void operator &=(IntVector n) { }
        public void operator |=(IntVector n) { }
        public void operator ^=(IntVector n) { }
        public void operator <<=(IntVector n) { }
        public void operator >>=(IntVector n) { }
        public void operator >>>=(IntVector n) { }
    }

    class TestOperator
    {
        void Main()
        {
            IntVector iv1 = new IntVector(4); // vector of 4 x 0
            IntVector iv2;
            iv2 = iv1++;  // iv2 contains 4 x 0, iv1 contains 4 x 1
            iv2 = ++iv1;  // iv2 contains 4 x 2, iv1 contains 4 x 2

            IntVector iv3 = new IntVector(4); // vector of 4 x 0
            iv3 += iv2;   // iv3 contains 4 x 2

            // The following operations don't do anything.
            iv3 -= iv2;
            iv3 *= iv2;
            iv3 /= iv2;
            iv3 %= iv2;
            iv3 &= iv2;
            iv3 |= iv2;
            iv3 ^= iv2;
            iv3 <<= iv2;
            iv3 >>= iv2;
            iv3 >>>= iv2;

            checked
            {
                iv3 += iv2;
                iv3 -= iv2;
                iv3 *= iv2;
                iv3 /= iv2;
            }
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
