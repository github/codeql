using System;
using System.Threading;

namespace ConstantWhileCondition
{
    class Main
    {
        const int ZERO = 0;

        public void Foo()
        {
            while (ZERO == 1 - 1)
            { // BAD
                break;
            }
            while (false)
            { // GOOD
                break;
            }
            while (true)
            { // GOOD
                break;
            }
            while (" " == " ")
            { // BAD
                break;
            }
            while (" "[0] == ' ')
            { // BAD: but not flagged
                break;
            }
            while (Bar() == 0)
            { // GOOD
                break;
            }
        }

        public int Bar()
        {
            return ZERO;
        }

    }

}
