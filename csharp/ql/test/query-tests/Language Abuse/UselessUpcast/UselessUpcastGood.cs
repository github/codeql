using System;

class Good
{
    class Super {}
    class SubA : Super {}
    class SubB : Super {}

    interface I1 { int Foo(); }
    interface I2 { float Foo(); }

    class C : I1, I2
    {
        public int Foo() => 23;
        float I2.Foo() => 9;
    }

    private static void Foo(Super super) => Console.WriteLine("Foo(Super)");
    private static void Foo(SubA suba) => Console.WriteLine("Foo(SubA)");

    void M()
    {
        var suba = new SubA();
        Foo((Super)suba);

        var c = new C();
        Console.WriteLine(((I2)c).Foo());

        var super = c == null ? (Super) new SubA() : new SubB();
    }
}
