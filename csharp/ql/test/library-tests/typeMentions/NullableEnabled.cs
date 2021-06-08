using System;

#nullable enable

public class Base { }
public class Derived : Base { }
public interface I0 { }
public interface I1 : I0 { }
public struct Str : I1 { }

public class C1
{
    public void M1()
    {
        Derived? d0 = new Derived();
        Derived d1 = new Derived();
        Str? s0 = new Str();
        Str s1 = new Str();
        I1? i0 = new Str();
        I1 i1 = new Str();
    }
}

// semmle-extractor-options: --separate-compilation