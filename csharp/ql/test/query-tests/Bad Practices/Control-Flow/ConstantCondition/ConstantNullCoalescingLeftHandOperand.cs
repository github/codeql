using System;

namespace ConstantNullCoalescingLeftHandOperand
{
    class Main
    {
        const object NULL_OBJECT = null;

        public void Foo()
        {
            object i = NULL_OBJECT ?? ""; // $ Alert
            object j = null ?? ""; // $ Alert
            object k = Bar() ?? ""; // GOOD
        }

        public object Bar()
        {
            return NULL_OBJECT;
        }

    }

}
