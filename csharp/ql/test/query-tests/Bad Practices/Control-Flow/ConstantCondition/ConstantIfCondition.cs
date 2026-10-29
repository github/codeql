using System;

namespace ConstantIfCondition
{
    class Main
    {
        const int ZERO = 0;

        public void Foo()
        {
            if (ZERO == 1 - 1) // $ Alert
            {
            }
            if (false) // GOOD
            {
            }
            if (" " == " ") // $ Alert
            {
            }
            if (" "[0] == ' ') // Missing Alert
            {
            }
            if (Bar() == 0) // GOOD
            {
            }
        }

        public int Bar()
        {
            return ZERO;
        }

        public void UnsignedCheck(byte n)
        {
            while (n >= 0) { n--; } // $ Alert
        }

    }

}
