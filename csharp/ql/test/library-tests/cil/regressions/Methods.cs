/*
 * A regression test for the CIL extractor - compiled into Methods.dll
 * This tests the correct extraction of F<T>, and we should end up with
 * 2 constructed methods of F<T>.
 */

namespace Methods
{
    public class Class1
    {
        public T F<T>(T t) { return new T[] { t }[0]; }

        public T G<T>(T t) { return F(t); }

        public T H<T>(T t) { return F(t); }
    }
}
