// Out of scope:
// - overloading
// - accessibility
// - other callables than methods
// - generics

namespace N1
{
    public class C1
    {
        public void // $ TypeMention=System.Void
        M1()
        { }

        public void // $ TypeMention=System.Void
        M2(C1 c1) // $ TypeMention=N1.C1
        {
            M1(); // $ StaticTarget=N1.C1.M1
            this.M1(); // $ StaticTarget=N1.C1.M1

            c1.M1(); // $ StaticTarget=N1.C1.M1

            C1 c2 = null; // $ TypeMention=N1.C1
            c2.M1(); // $ StaticTarget=N1.C1.M1

            var c3 = new C1(); // $ TypeMention=N1.C1 $ StaticTarget=N1.C1.C1
            c3.M1(); // $ StaticTarget=N1.C1.M1

            M3(). // $ StaticTarget=N1.C1.M3
            M1(); // $ StaticTarget=N1.C1.M1

            var c4 = M3(); // $ StaticTarget=N1.C1.M3
            c4.M1(); // $ StaticTarget=N1.C1.M1
        }

        public C1 M3() => throw null; // $ TypeMention=N1.C1
    } // $ Class=N1.C1
}

namespace N2
{
    using N1;

    public class C1
    {
        public void // $ TypeMention=System.Void
        M1(
            C1 c1 = null,  // $ TypeMention=N2.C1
            N1.C1 c2 = null // $ TypeMention=N1.C1
        )
        {
            c1.M1(); // $ StaticTarget=N2.C1.M1
            c2.M1(); // $ StaticTarget=N1.C1.M1
        }
    } // $ Class=N2.C1

    public class C2 : C1 // $ TypeMention=N2.C1
    {
        public void // $ TypeMention=System.Void
        M2()
        {
            M1(); // $ StaticTarget=N2.C1.M1
            this.M1(); // $ StaticTarget=N2.C1.M1
            base.M1(); // $ StaticTarget=N2.C1.M1

            C1 c1 = // $ TypeMention=N2.C1
                new C2(); // $ TypeMention=N2.C2 $ StaticTarget=N2.C2.C2
            c1.M1(); // $ StaticTarget=N2.C1.M1
        }
    } // $ Class=N2.C2

    public class C3 : C2 // $ TypeMention=N2.C2
    {
        public new void // $ TypeMention=System.Void
        M2()
        {
            M2(); // $ StaticTarget=N2.C3.M2
            C3 c3 = null; // $ TypeMention=N2.C3
            c3.M2(); // $ StaticTarget=N2.C3.M2
            C2 c2 = c3; // $ TypeMention=N2.C2
            c2.M2(); // $ StaticTarget=N2.C2.M2
        }
    } // $ Class=N2.C3
}

namespace N3
{
    using N1;

    public class C2
    {
        C1 Field1; // $ TypeMention=N1.C1
        N1.C1 Field2; // $ TypeMention=N1.C1
        C2 Field3; // $ TypeMention=N3.C2

        C1 Prop1 => null; // $ TypeMention=N1.C1
        N1.C1 Prop2 => null; // $ TypeMention=N1.C1
        C2 Prop3 { get; set; } // $ TypeMention=N3.C2

        public void // $ TypeMention=System.Void
        M1(
            C1 c1, // $ TypeMention=N1.C1
            N1.C1 c2 // $ TypeMention=N1.C1
        )
        {
            c1.M1(); // $ StaticTarget=N1.C1.M1
            c2.M1(); // $ StaticTarget=N1.C1.M1

            Field1.M1(); // $ StaticTarget=N1.C1.M1
            Field2.M1(); // $ StaticTarget=N1.C1.M1
            Field3.M1(null, null); // $ StaticTarget=N3.C2.M1
            {
                // shadows outer field
                C2 Field1 = null; // $ TypeMention=N3.C2
                Field1.M1(null, null); // $ StaticTarget=N3.C2.M1
                this.Field1.M1(); // $ StaticTarget=N1.C1.M1
            }

            Prop1. // $ StaticTarget=N3.C2.get_Prop1
            M1(); // $ StaticTarget=N1.C1.M1
            Prop2. // $ StaticTarget=N3.C2.get_Prop2
            M1(); // $ StaticTarget=N1.C1.M1
            Prop3. // $ StaticTarget=N3.C2.get_Prop3
            M1(null, null); // $ StaticTarget=N3.C2.M1
            Prop3 = null;  // $ StaticTarget=N3.C2.set_Prop3
            {
                // shadows outer property
                N2.C2 Prop1 = null; // $ TypeMention=N2.C2
                Prop1.M1(); // $ StaticTarget=N2.C1.M1
                this.Prop1. // $ StaticTarget=N3.C2.get_Prop1
                M1(); // $ StaticTarget=N1.C1.M1
            }
        }
    } // $ Class=N3.C2
}

namespace N4
{
    public class C1
    {
        public virtual void // $ TypeMention=System.Void
        M1()
        {
            this.M1(); // $ StaticTarget=N4.C1.M1
        }
    } // $ Class=N4.C1

    public class C2 : C1 // $ TypeMention=N4.C1
    {
        public override void // $ TypeMention=System.Void
        M1()
        {
            this.M1(); // $ StaticTarget=N4.C2.M1
            base.M1(); // $ StaticTarget=N4.C1.M1
        }
    } // $ Class=N4.C2
}

namespace N5
{
    public class C1 : N4.C1 // $ TypeMention=N4.C1
    {
        public void // $ TypeMention=System.Void
        M2()
        {
            this.M1(); // $ StaticTarget=N4.C1.M1
        }

        public static void M3() { } // $ TypeMention=System.Void
    } // $ Class=N5.C1

    public class C2 : N4.C1 // $ TypeMention=N4.C1
    {
        public override void // $ TypeMention=System.Void
        M1()
        {
            this.M1(); // $ StaticTarget=N5.C2.M1
            base.M1(); // $ StaticTarget=N4.C1.M1
        }

        public static void M2() { } // $ TypeMention=System.Void
    } // $ Class=N5.C2
}

namespace N6
{
    using N4;
    using NamespaceAlias = N5;
    using TypeAlias = N5.C2; // $ TypeMention=N5.C2
    using C2 = N5.C2; // $ TypeMention=N5.C2

    public class C1
    {
        public void // $ TypeMention=System.Void
        M1(
            NamespaceAlias::C2 c1, // $ TypeMention=N5.C2
            NamespaceAlias.C2 c2, // $ TypeMention=N5.C2
            TypeAlias c3, // $ TypeMention=N5.C2
            C2 c4, // $ TypeMention=N5.C2
            global::N5.C1 c5 // $ TypeMention=N5.C1
        )
        {
            c1.M1(); // $ StaticTarget=N5.C2.M1
            c2.M1(); // $ StaticTarget=N5.C2.M1
            c3.M1(); // $ StaticTarget=N5.C2.M1
            c4.M1(); // $ StaticTarget=N5.C2.M1
            c5.M1(); // $ StaticTarget=N4.C1.M1
            NamespaceAlias.C1. // $ TypeMention=N5.C1
            M3(); // $ StaticTarget=N5.C1.M3
            TypeAlias. // $ TypeMention=N5.C2
            M2(); // $ StaticTarget=N5.C2.M2
        }

        public static void // $ TypeMention=System.Void
        M2()
        { }

        public static void // $ TypeMention=System.Void
        M3()
        { }

        public static C1 // $ TypeMention=N6.C1
        Prop1
        { get; }

        public static C1 // $ TypeMention=N6.C1
        Prop2
        { get; }
    } // $ Class=N6.C1
}

namespace N7
{
    public class C1
    {
        public void // $ TypeMention=System.Void
        M1()
        {
            N6.C1. // $ TypeMention=N6.C1
            M2(); // $ StaticTarget=N6.C1.M2
        }
    } // $ Class=N7.C1
}

namespace N8
{
    using static N6.C1; // $ TypeMention=N6.C1

    public class C1
    {
        public void // $ TypeMention=System.Void
        M1()
        {
            M2(); // $ StaticTarget=N6.C1.M2

            var x = Prop1; // $ StaticTarget=N6.C1.get_Prop1

            N6.C1. // $ TypeMention=N6.C1
            M2(); // $ StaticTarget=N6.C1.M2

            x = N6.C1. // $ TypeMention=N6.C1
            Prop1; // $ StaticTarget=N6.C1.get_Prop1

            M3(); // $ StaticTarget=N8.C1.M3

            var y = Prop2; // $ StaticTarget=N8.C1.get_Prop2

            C1. // $ TypeMention=N8.C1
            M3(); // $ StaticTarget=N8.C1.M3

            y = C1. // $ TypeMention=N8.C1
            Prop2; // $ StaticTarget=N8.C1.get_Prop2

            C1. // $ TypeMention=N8.C1
            M3(); // $ StaticTarget=N8.C1.M3

            y = C1. // $ TypeMention=N8.C1
            Prop2; // $ StaticTarget=N8.C1.get_Prop2

            N8.C1. // $ TypeMention=N8.C1
            M3(); // $ StaticTarget=N8.C1.M3

            y = N8.C1. // $ TypeMention=N8.C1
            Prop2; // $ StaticTarget=N8.C1.get_Prop2
        }

        public static void // $ TypeMention=System.Void
        M3()
        { }

        public static C1 // $ TypeMention=N8.C1
        Prop2
        { get; }

        class C2
        {
            void  // $ TypeMention=System.Void
            M()
            {
                M2(); // $ StaticTarget=N6.C1.M2
                M3(); // $ StaticTarget=N8.C1.M3
                var x = Prop1; // $ StaticTarget=N6.C1.get_Prop1
                var y = Prop2; // $ StaticTarget=N8.C1.get_Prop2
            }

        } // $ Class=N8.C1+C2
    } // $ Class=N8.C1
}

namespace N9
{
    public class C1
    {
        public C1(int i) { }            // $ TypeMention=System.Int32

        public static int M1() => 5;    // $ TypeMention=System.Int32
    } // $ Class=N9.C1

    public class C2 :
        C1 // $ TypeMention=N9.C1
    {
        C2() : base(
            M1()    // $ StaticTarget=N9.C1.M1
            )       // $ StaticTarget=N9.C1.C1
        { }

        C2(int i)       // $ TypeMention=System.Int32
            : this()    // $ StaticTarget=N9.C2.C2()
        { }
    } // $ Class=N9.C2
}

namespace N10
{
    public class X1
    {
        public int M1() => 5;       // $ TypeMention=System.Int32
    }// $ Class=N10.X1
}

namespace N11
{
    class C1
    {
        public static void M1() { } // $ TypeMention=System.Void

        public void M2() { } // $ TypeMention=System.Void
    } // $ Class=N11.C1

    class C2
    {
        C2 C1; // $ TypeMention=N11.C2

        void M1() { } // $ TypeMention=System.Void

        void M() // $ TypeMention=System.Void
        {
            N11.C1. // $ TypeMention=N11.C1
            M1(); // $ StaticTarget=N11.C1.M1

            C1.M1(); // $ StaticTarget=N11.C2.M1
        }
    } // $ Class=N11.C2

    class C3
    {
        C1 C1; // $ TypeMention=N11.C1

        void M() // $ TypeMention=System.Void
        {
            C1. // $ TypeMention=N11.C1
            M1(); // $ StaticTarget=N11.C1.M1

            C1.
            M2(); // $ StaticTarget=N11.C1.M2
        }
    } // $ Class=N11.C3

    class C4
    {
        C4 C1 { get; set; } // $ TypeMention=N11.C4

        public void M1() { } // $ TypeMention=System.Void

        void M() // $ TypeMention=System.Void
        {
            C1. // $ StaticTarget=N11.C4.get_C1
            M1(); // $ StaticTarget=N11.C4.M1
        }
    } // $ Class=N11.C4

    class C5
    {
        C1 C1 { get; set; } // $ TypeMention=N11.C1

        void M() // $ TypeMention=System.Void
        {
            C1. // $ TypeMention=N11.C1
            M1(); // $ StaticTarget=N11.C1.M1

            C1. // $ StaticTarget=N11.C5.get_C1
            M2(); // $ StaticTarget=N11.C1.M2
        }
    } // $ Class=N11.C5

    class C6
    {
        void M1() { } // $ TypeMention=System.Void

        void // $ TypeMention=System.Void
        M(C4 C1) // $ TypeMention=N11.C4
        {
            C1.M1(); // $ StaticTarget=N11.C4.M1

            C1 c = null; // $ TypeMention=N11.C1
        }
    } // $ Class=N11.C6

    class C7
    {
        void // $ TypeMention=System.Void
        M(C1 C1) // $ TypeMention=N11.C1
        {
            C1. // $ TypeMention=N11.C1
            M1(); // $ StaticTarget=N11.C1.M1

            C1.
            M2(); // $ StaticTarget=N11.C1.M2
        }
    } // $ Class=N11.C7
}

namespace N12
{
    namespace A
    {
        class B
        {
            public static void M1() { } // $ TypeMention=System.Void

            void M2() // $ TypeMention=System.Void
            {
                A.B. // $ TypeMention=N12.A.B
                M1(); // $ StaticTarget=N12.A.B.M1
            }

        } // $ Class=N12.A.B
    }
}

namespace N12.N
{
    using Alias = A; // $ TypeMention=N12.N.A

    class A
    {
        class B
        {
            public static void M1() { } // $ TypeMention=System.Void
        } // $ Class=N12.N.A+B

        void M2() // $ TypeMention=System.Void
        {
            A.B. // $ TypeMention=N12.N.A+B
            M1(); // $ StaticTarget=N12.N.A+B.M1
        }
    } // $ Class=N12.N.A
}
