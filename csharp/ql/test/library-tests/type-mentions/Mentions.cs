unsafe class C : System.Exception
{
    void M1(
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

    void M2(delegate*<int, void> f, int* x) { }
} // $ Class=C

class C2<T>
{
    C2<
      C // $ TypeMention=C
    > // $ TypeMention=C2`1
    M() => null;

    void M2(int? i) { }
} // $ Class=C2`1

namespace N1
{
    class C3
    {
        class C4 { } // $ Class=N1.C3+C4

        void M(
            N1.C3 p1, // $ TypeMention=N1.C3
            N1.C3.C4 p2, // $ TypeMention=N1.C3+C4
            C3.C4 p3 // $ TypeMention=N1.C3+C4
        )
        { }

        void M2(global::System.Int32 i) { }

        void M3(ref int i) // not a ref type
        {
            ref int j = ref i;
            scoped ref int k = ref j;
            (int, string) tuple;
        }
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
                void M(
                    C3 p1, // $ TypeMention=N2.N3.C2+C3
                    C2.C3 p2, // $ TypeMention=N2.N3.C2+C3
                    N3.C2.C3 p3, // $ TypeMention=N2.N3.C2+C3
                    N2.N3.C3 p4, // $ TypeMention=N2.N3.C3
                    C2 p5 // $ TypeMention=N2.N3.C2
                )
                { }
            } // $ Class=N2.N3.C2+C3
        } // $ Class=N2.N3.C2

        public class C3
        {
            void M(
                C3 p1, // $ TypeMention=N2.N3.C3
                C2.C3 p2, // $ TypeMention=N2.N3.C2+C3
                N3.C2.C3 p3, // $ TypeMention=N2.N3.C2+C3
                N2.N3.C3 p4, // $ TypeMention=N2.N3.C3
                N3.C3 p5, // $ TypeMention=N2.N3.C3
                C2 p6 // $ TypeMention=N2.N3.C2
            )
            { }
        } // $ Class=N2.N3.C3
    }
}
