using static N6.C1; // $ TypeMention=N6.C1
using TypeAlias = N6.C1; // $ TypeMention=N6.C1
using N10;

namespace N6
{
    using C2 = N4.C2; // $ TypeMention=N4.C2

    public class C3
    {
        void // $ TypeMention=System.Void
        M(
            C1 c1, // $ TypeMention=N6.C1
            TypeAlias c2, // $ TypeMention=N6.C1
            C2 c3 // $ TypeMention=N4.C2
        )
        {
            c1.M1(null, null, null, null, null); // $ StaticTarget=N6.C1.M1
            c2.M1(null, null, null, null, null); // $ StaticTarget=N6.C1.M1
            c3.M1(); // $ StaticTarget=N4.C2.M1
            M2(); // $ StaticTarget=N6.C1.M2
            TypeAlias. // $ TypeMention=N6.C1
            M2(); // $ StaticTarget=N6.C1.M2
        }

        X1 field1;  // $ TypeMention=N10.X1

        void    // $ TypeMention=System.Void
        M4()
        {
            field1.M1(); // $ StaticTarget=N10.X1.M1
        }
    } // $ Class=N6.C3

    public class C4a : X1 // $ TypeMention=N10.X1
    {
        void    // $ TypeMention=System.Void
        M()
        {
            M1(); // $ StaticTarget=N10.X1.M1
        }
    } // $ Class=N6.C4a

    public class C4b : N10.X1 // $ TypeMention=N10.X1
    {
        void    // $ TypeMention=System.Void
        M()
        {
            M1(); // $ StaticTarget=N10.X1.M1
        }
    } // $ Class=N6.C4b
}