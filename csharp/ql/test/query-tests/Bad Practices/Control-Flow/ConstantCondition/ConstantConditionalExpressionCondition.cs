using System;

namespace ConstantConditionalExpression
{
    class Main
    {
        const int ZERO = 0;

        public void Foo()
        {
            int i = (ZERO == 1 - 1) ? 0 : 1; // $ Alert
            int j = false ? 0 : 1; // $ Alert
            int k = " " == " " ? 0 : 1; // $ Alert
            int l = (" "[0] == ' ') ? 0 : 1; // Missing Alert
            int m = Bar() == 0 ? 0 : 1; // GOOD
        }

        public int Bar()
        {
            return ZERO;
        }

    }
}
