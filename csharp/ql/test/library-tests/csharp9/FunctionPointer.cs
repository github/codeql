using System;

public class FnPointer
{
    public unsafe static class Program
    {
        static delegate*<int> pointer = &M0;

        public static int M0()
        {
            return 0;
        }

        static void M1(delegate*<ref int, out object?, ref readonly int> f)
        {
            int i = 42;
            int j = f(ref i, out object? o);
        }

        static void M2<T>(delegate* unmanaged[Stdcall/*, StdcallSuppressGCTransition*/]<ref int, out object?, T, void> f) where T : new()
        {
            int i = 42;
            f(ref i, out object? o, new T());
        }

        static void M3(delegate* managed<ref int, out object?, in int, ref int> f)
        {
            int i = 42;
            ref int j = ref f(ref i, out object? o, in i);
        }

        static void M4<T>(delegate*<T, int> f) where T : new()
        {
            int j = f(new T());
        }

        static void M5(delegate*<B, A> f, delegate*<A, B> ff)
        {
            M5(ff, ff); // implicit conversion due to implicit reference conversion
        }

        static void M6(delegate*<int*, void*> f, delegate*<void*, int*> ff)
        {
            M6(ff, ff); // implicit conversion due to implicit pointer conversion
        }

        class A { }
        class B : A { }
    }
}
