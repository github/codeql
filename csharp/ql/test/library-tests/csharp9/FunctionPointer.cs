using System;

public class Class1
{
    public unsafe static class Program
    {
        static delegate*<int> pointer = &Main;

        public static int Main()
        {
            return 0;
        }

        static void Example(Action<int> a, delegate*<int, void> f)
        {
            a(42);
            f(42);
        }
    }


}