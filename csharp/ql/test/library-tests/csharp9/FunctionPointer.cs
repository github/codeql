using System;

#nullable enable

public class Class1
{
    public unsafe static class Program
    {
        static delegate*<int> pointer = &Main;

        public static int Main()
        {
            return 0;
        }

        static void M1(delegate*<ref int, out object?, int> f)
        {
            int i = 42;
            int j = f(ref i, out object? o);
        }

        static void M2<T>(delegate* unmanaged[Stdcall, SuppressGCTransition]<ref int, out object?, T, void> f) where T : new()
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
    }
}