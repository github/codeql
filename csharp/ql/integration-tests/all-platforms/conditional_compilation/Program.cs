public class Test
{
    public static void Main()
    {
        Greet();
        GreetConditional1();
        GreetConditional2();
    }

    static void GreetConditional1()
    {
#if A
    Console.WriteLine("Hello, A!");
#elif C
    Console.WriteLine("Hello, C!");
#endif
    }

    static void Greet()
    {
        Console.WriteLine("Hello, World!");
    }

#if A
    static void GreetConditional2()
    {
        Console.WriteLine("Hello, A!");
    }
#elif B
    static void GreetConditional2()
    {
        Console.WriteLine("Hello, B!");
    }
#else
    static void GreetConditional2()
    {
        Console.WriteLine("Hello, Others!");
    }
#endif
}
