using System;
using System.IO;
using System.Collections.Generic;

namespace N1.N2
{

    class A { }
    class B { }

}

namespace M1
{

    namespace M2
    {

        public class A { }
        internal class B { }

    }

}

namespace P1.P2
{

    class A { }

}

namespace P1.P2
{

    class B { }

    struct S { }

    interface I { }

}

namespace Empty
{


}

namespace Q1.Q2
{

    class A { }

}

namespace Q3
{

    using A = Q1.Q2.A;

    using R = Q1.Q2;

    class B : A { }

    class C : R.A { }

}

namespace R1
{

    class A<T>
    {

        class B { }

    }

    class A { }

}

namespace R2
{

    using Y = R1.A<int>;

}

namespace S1.S2
{

    class A { }
}

namespace S3
{

    using S1.S2;

    class B : A { }

}
