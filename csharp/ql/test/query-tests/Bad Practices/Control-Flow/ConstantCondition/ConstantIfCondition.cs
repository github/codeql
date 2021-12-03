using System;

namespace ConstantIfCondition
{
    class Main
    {
        const int ZERO = 0;

        public void Foo()
        {
            if (ZERO == 1 - 1)
            { // BAD
            }
            if (false)
            { // BAD
            }
            if (" " == " ")
            { // BAD
            }
            if (" "[0] == ' ')
            { // BAD: but not flagged
            }
            if (Bar() == 0)
            { // GOOD
            }
        }

        public int Bar()
        {
            return ZERO;
        }

    }

}
