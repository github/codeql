
class GenericsTest
{
    class C1 { }
    class C2 { }
    class C3 { }
    class C4 { }
    class C5 { }
    class C6 { }
    class C7 { }
    class C8 { }
    class C9 { }
    class C10 { }
    class C11 { }
    class C12 { }
    class C13 { }
    class C14 { }
    class C15 { }
    class C16 { }
    class C17 { }
    class C18 { }
    class C19 { }
    class C20 { }
    class C21 { }
    class C22 { }

    class C<T>
    {
        string s = "InitialValue";
    }

    // Regression here: "Argument" should be treated as one literal,
    // not as one per construction (ODASA-2004)
    void f<T>(string s = "Argument")
    {
        var x = new C<T>();
    }

    void Test()
    {
        f<C1>();
        f<C2>();
        f<C3>();
        f<C4>();
        f<C5>();
        f<C6>();
        f<C7>();
        f<C8>();
        f<C9>();
        f<C10>();
        f<C11>();
        f<C12>();
        f<C13>();
        f<C14>();
        f<C15>();
        f<C16>();
        f<C17>();
        f<C18>();
        f<C19>();
        f<C20>();
        f<C21>();
        f<C22>();
    }
}
