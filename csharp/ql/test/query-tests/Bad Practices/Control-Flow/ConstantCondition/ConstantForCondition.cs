using System;

namespace ConstantForCondition
{
    class Main
    {
        public void M()
        {
            for (int i = 0; false; i++) // $ Alert
                ;
            for (int i = 0; 0 == 1; i++) // $ Alert
                ;
            for (; ; ) // GOOD
                ;
        }
    }
}
