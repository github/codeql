using System;

namespace ConstantNullCoalescingLeftHandOperand
{
    class Main
    {
        const object NULL_OBJECT = null;

        public void Foo()
        {
            object i = NULL_OBJECT ?? ""; // BAD
            object j = null ?? ""; // BAD
            object k = Bar() ?? ""; // GOOD
        }

        public object Bar()
        {
            return NULL_OBJECT;
        }

    }

}
