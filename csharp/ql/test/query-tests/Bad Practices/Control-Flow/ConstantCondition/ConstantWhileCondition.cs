using System;
using System.Threading;

namespace ConstantWhileCondition
{
    class Main
    {
        const int ZERO = 0;

        public void Foo()
        {
            while (ZERO == 1 - 1) // $ Alert
            {
                break;
            }
            while (false) // $ Alert
            {
                break;
            }
            while (true) // GOOD
            {
                break;
            }
            while (" " == " ") // $ Alert
            {
                break;
            }
            while (" "[0] == ' ') // Missing Alert
            {
                break;
            }
            while (Bar() == 0) // GOOD
            {
                break;
            }
        }

        public int Bar()
        {
            return ZERO;
        }

    }

}
