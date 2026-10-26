using System;
using System.Threading;

namespace ConstantDoCondition
{
    class Main
    {
        const int ZERO = 0;

        public void Foo()
        {
            do
            {
                break;
            } while (ZERO == 1 - 1); // $ Alert
            do
            {
                break;
            } while (false); // BAD
            do
            {
                break;
            } while (true); // BAD
            do
            {
                Thread.Sleep(20);
                break;
            } while (true); // GOOD: the loop deals with threading
            do
            {
                break;
            } while (" " == " ");  // $ Alert
            do
            {
                break;
            } while (" "[0] == ' '); // BAD: but not flagged
            do
            {
                break;
            } while (Bar() == 0); // GOOD
        }

        public int Bar()
        {
            return ZERO;
        }

    }

}
