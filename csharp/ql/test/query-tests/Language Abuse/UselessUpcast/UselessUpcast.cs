// semmle-extractor-options: /r:System.Linq.dll

using System;
using System.Collections.Generic;
using System.Linq;

interface I1 { int Foo(); }
interface I2 { float Foo(); }

class A : I1, I2
{
    public int Foo() { return 0; }
    float I2.Foo() { return 0; }
    public void M(A a) { }
}

class B : A
{
    public static bool operator==(B b1, B b2) { return false; }
    public static bool operator!=(B b1, B b2) { return true; }
    public void M(B b) { }
}

class C : B { }

class D : C { }

static class AExtensions1
{
    public static void M1(this A a, A x) { }
    public static void M2(this A a, A x) { }
}

static class AExtensions2
{
    public static void M2(this A a, B b) { }
}

class Tests
{
    void Fn(A a) { }
    void Fn(B a) { }
    void Fn2(A a) { }

    void Fn(string[] args)
    {
        A a = new A();
        B b = new B();
        object o;

        o = (A)b; // BAD

        o = (B)b; // GOOD: Not an upcast

        b.M((A)b); // GOOD: Disambiguating method call

        a.M1((A)b); // BAD
        a.M2((A)b); // GOOD: Disambiguating method call

        o = true ? (A)a : b; // GOOD: Needed for ternary

        o = a ?? (A)b; // GOOD: Null coalescing expression

        Fn((A)b); // GOOD: Disambiguating method call

        Fn2((A)b); // BAD

        ((I2)a).Foo(); // GOOD: Cast to an interface

        o = a==(A)b; // GOOD: EQExpr

        o = b==(B)b; // GOOD: Operator call

        var act = (Action) (() => { }); // GOOD

        var objects = args.Select(s => (object)s); // GOOD
    }
}
