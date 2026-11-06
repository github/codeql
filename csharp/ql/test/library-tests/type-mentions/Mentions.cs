unsafe class C : System.Exception
{
    void // $ TypeMention=System.Void
    M1(
        C c1, // $ TypeMention=C
        C[] c2
        )
    {
        C x = // $ TypeMention=C
            c1 as C; // $ TypeMention=C
        if (c1 is C) // $ TypeMention=C
            ;
        try
        {
            new C(); // $ TypeMention=C
        }
        catch (C) // $ TypeMention=C
        {
        }
    }

    void // $ TypeMention=System.Void
    M2(delegate*<int, void> f, int* x)
    { }
} // $ Class=C

class C2<T>
{
    C2< // $ TypeMention=C2`1
      C // $ TypeMention=C
    > // $ TypeMention=C2<C>
    M() => null;

    void // $ TypeMention=System.Void
    M2(int? i)
    { }

    class C2Nested
    {
    } // $ Class=C2`1+C2Nested

    C2< // $ TypeMention=C2`1
      C // $ TypeMention=C
    >. // $ TypeMention=C2<C>
    C2Nested // $ TypeMention=C2<C>+C2Nested
    M3() => null;

    C2< // $ TypeMention=C2`1
      C2< // $ TypeMention=C2`1
        C // $ TypeMention=C
      > // $ TypeMention=C2<C>
    > // $ TypeMention=C2<C2<C>>
    M4() => null;

    class C2Nested<T1, T2>
    {
    } // $ Class=C2`1+C2Nested`2

    C2< // $ TypeMention=C2`1
      C // $ TypeMention=C
    >. // $ TypeMention=C2<C>
    C2Nested< // $ TypeMention=C2<C>+C2Nested`2
      int, // $ TypeMention=System.Int32
      string // $ TypeMention=System.String
    > // $ TypeMention=C2<C>+C2Nested<System.Int32,System.String>
    M5() => null;
} // $ Class=C2`1

namespace N1
{
    class C3
    {
        class C4 { } // $ Class=N1.C3+C4

        void // $ TypeMention=System.Void
        M(
            N1.C3 p1, // $ TypeMention=N1.C3
            N1.C3. // $ TypeMention=N1.C3
            C4 p2, // $ TypeMention=N1.C3+C4
            C3. // $ TypeMention=N1.C3
            C4 p3 // $ TypeMention=N1.C3+C4
        )
        { }

        void // $ TypeMention=System.Void
        M2(global::System.Int32 i) // $ TypeMention=System.Int32
        { }

        void // $ TypeMention=System.Void
        M3(ref      // not a ref type
            int i)  // $ TypeMention=System.Int32
        {
            ref int j = ref i;
            scoped ref int k = ref j;
            (int,                       // $ TypeMention=System.Int32
                string) tuple;          // $ TypeMention=System.String
        }

        class C4Nested<T1>
        {
        } // $ Class=N1.C3+C4Nested`1

        C3. // $ TypeMention=N1.C3
        C4Nested< // $ TypeMention=N1.C3+C4Nested`1
          int // $ TypeMention=System.Int32
        > // $ TypeMention=N1.C3+C4Nested<System.Int32>
        M4() => null;
    } // $ Class=N1.C3
}

namespace N2
{
    namespace N3
    {
        public class C2
        {
            public class C3
            {
                void // $ TypeMention=System.Void
                M(
                    C3 p1, // $ TypeMention=N2.N3.C2+C3
                    C2. // $ TypeMention=N2.N3.C2
                    C3 p2, // $ TypeMention=N2.N3.C2+C3
                    N3.C2. // $ TypeMention=N2.N3.C2
                    C3 p3, // $ TypeMention=N2.N3.C2+C3
                    N2.N3.C3 p4, // $ TypeMention=N2.N3.C3
                    C2 p5 // $ TypeMention=N2.N3.C2
                )
                { }
            } // $ Class=N2.N3.C2+C3
        } // $ Class=N2.N3.C2

        public class C3
        {
            void // $ TypeMention=System.Void
            M(
                C3 p1, // $ TypeMention=N2.N3.C3
                C2. // $ TypeMention=N2.N3.C2
                C3 p2, // $ TypeMention=N2.N3.C2+C3
                N3.C2. // $ TypeMention=N2.N3.C2
                C3 p3, // $ TypeMention=N2.N3.C2+C3
                N2.N3.C3 p4, // $ TypeMention=N2.N3.C3
                N3.C3 p5, // $ TypeMention=N2.N3.C3
                C2 p6 // $ TypeMention=N2.N3.C2
            )
            { }
        } // $ Class=N2.N3.C3
    }
}

namespace N4
{
    // public class C
    // {
    //     C.
    //     C2 // $ TypeMention=N4.C.C2
    //     field;

    //     void M() // $ TypeMention=System.Void
    //     {
    //         C.
    //         C2. // $ TypeMention=N4.C.C2
    //         M();
    //     }
    // } // $ Class=N4.C

    // namespace C
    // {
    //     public class C2
    //     {
    //         public static void M() { } // $ TypeMention=System.Void
    //     } // $ Class=N4.C.C2
    // }
}

namespace N5
{
    class MyAttribute : System.Attribute
    {
        public MyAttribute(
            int i // $ TypeMention=System.Int32
        )
        { }
    } // $ Class=N5.MyAttribute

    [MyAttribute(1)] // $ TypeMention=N5.MyAttribute
    class C1 { } // $ Class=N5.C1

    [My(2)] // $ TypeMention=N5.MyAttribute
    class C2 { } // $ Class=N5.C2

    class MyGenericAttribute<T> : System.Attribute { } // $ Class=N5.MyGenericAttribute`1
    class MyGeneric2Attribute<T, U> : System.Attribute { } // $ Class=N5.MyGeneric2Attribute`2

    [
        MyGenericAttribute< // $ TypeMention=N5.MyGenericAttribute`1
            int // $ TypeMention=System.Int32
        >() // $ TypeMention=N5.MyGenericAttribute<System.Int32>
    ]
    class C3 { } // $ Class=N5.C3

    [
        MyGeneric< // $ TypeMention=N5.MyGenericAttribute`1
            string // $ TypeMention=System.String
        >() // $ TypeMention=N5.MyGenericAttribute<System.String>
    ]
    class C4 { } // $ Class=N5.C4

    [
        MyGeneric2< // $ TypeMention=N5.MyGeneric2Attribute`2
            int, // $ TypeMention=System.Int32
            string // $ TypeMention=System.String
        >() // $ TypeMention=N5.MyGeneric2Attribute<System.Int32,System.String>
    ]
    class C5 { } // $ Class=N5.C5
}

namespace N6
{
    class C1<T>
    {
        T // $ TypeMention=N6.C1`1#T
        M1() => throw null;

        void M2<T>( // $ TypeMention=System.Void
            T x // $ TypeMention=N6.C1`1.M2`1#T
        ) => throw null;

        class C2<T>
        {
            T // $ TypeMention=N6.C1`1+C2`1#T
            M() => throw null;
        } // $ Class=N6.C1`1+C2`1

        class C3
        {
            class T
            {
            } // $ Class=N6.C1`1+C3+T

            T // $ TypeMention=N6.C1`1+C3+T
            M() => throw null;
        } // $ Class=N6.C1`1+C3

        void M3<T>( // $ TypeMention=System.Void
            T x // $ TypeMention=N6.C1`1.M3`1#T
        )
        {
            void LocalFunc<T>(
                T x // $ TypeMention=N6.C1`1.M3`1.LocalFunc`1#T
            )
            {
                void InnerLocalFunc<T>(
                    T x // $ TypeMention=N6.C1`1.M3`1.LocalFunc`1.InnerLocalFunc`1#T
                )
                {
                }
            }
        }
    } // $ Class=N6.C1`1
}