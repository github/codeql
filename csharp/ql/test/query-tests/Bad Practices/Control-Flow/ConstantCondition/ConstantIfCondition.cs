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
            if (false) // $ Alert
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

        public int Max(int a, int b)
        {
            return a > a ? a : b; // $ Alert
        }

        public int Bar()
        {
            return ZERO;
        }

    }

}
