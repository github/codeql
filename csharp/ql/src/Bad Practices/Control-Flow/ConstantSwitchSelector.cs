using System;

namespace ConstantSwitchSelector
{
    class Main
    {
        const int ZERO = 0;

        public void Foo()
        {
            switch (ZERO + 1)
            { // BAD
                case 1: break;
            }
            switch ('a')
            { // BAD
                default: break;
            }
            switch (Bar())
            { // GOOD
                case 1: break;
            }
        }

        public int Bar()
        {
            return ZERO;
        }

    }

}
