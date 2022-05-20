using System;

namespace ConstantConditionalExpression
{
    class Main
    {
        const int ZERO = 0;

        public void Foo()
        {
            int i = (ZERO == 1 - 1) ? 0 : 1; // BAD
            int j = false ? 0 : 1; // BAD
            int k = " " == " " ? 0 : 1; // BAD
            int l = (" "[0] == ' ') ? 0 : 1; // BAD: but not flagged
            int m = Bar() == 0 ? 0 : 1; // GOOD
        }

        public int Bar()
        {
            return ZERO;
        }

    }

}
