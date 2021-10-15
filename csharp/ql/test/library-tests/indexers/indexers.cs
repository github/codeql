using System;
using System.IO;
using System.Collections.Generic;

namespace Indexers
{

    public class BitArray
    {

        int[] bits;
        int length;

        public BitArray(int length)
        {
            if (length < 0)
                throw new ArgumentException();
            bits = new int[((length - 1) >> 5) + 1];
            this.length = length;
        }

        public int Length { get { return length; } }

        public bool this[int index]
        {
            get
            {
                if (index < 0 || index >= length)
                {
                    throw new IndexOutOfRangeException();
                }
                return (bits[index >> 5] & 1 << index) != 0;
            }
            set
            {
                if (index < 0 || index >= length)
                {
                    throw new IndexOutOfRangeException();
                }
                if (value)
                {
                    bits[index >> 5] |= 1 << index;
                }
                else
                {
                    bits[index >> 5] &= ~(1 << index);
                }
            }

        }
    }

    public class CountPrimes
    {

        static int Count(int max)
        {
            BitArray flags = new BitArray(max + 1);
            int count = 1;
            for (int i = 2; i <= max; i++)
            {
                if (!flags[i])
                {
                    for (int j = i * 2; j <= max; j += i)
                        flags[j] = true;
                    count++;
                }
            }
            return count;
        }

        static void Main(string[] args)
        {
            int max = int.Parse(args[0]);
            int count = Count(max);
            Console.WriteLine("Found {0} primes between 1 and {1}", count, max);
        }

    }

    public class Grid
    {

        const int NumRows = 26;
        const int NumCols = 10;

        int[,] cells = new int[NumRows, NumCols];

        public int this[char c, int col]
        {
            get
            {
                c = Char.ToUpper(c);
                if (c < 'A' || c > 'Z')
                {
                    throw new ArgumentException();
                }
                if (col < 0 || col >= NumCols)
                {
                    throw new IndexOutOfRangeException();
                }
                return cells[c - 'A', col];
            }
            set
            {
                c = Char.ToUpper(c);
                if (c < 'A' || c > 'Z')
                {
                    throw new ArgumentException();
                }
                if (col < 0 || col >= NumCols)
                {
                    throw new IndexOutOfRangeException();
                }
                cells[c - 'A', col] = value;
            }
        }

    }

    public class DuplicateIndexerSignatures
    {
        public bool this[int index]
        {
            get { return false; }
        }

        public int this[char c, int col]
        {
            get { return 0; }
        }
    }
}
