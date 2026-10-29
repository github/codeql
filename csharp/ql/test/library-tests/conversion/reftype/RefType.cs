using System;
using System.Collections.Generic;

interface I1<in T> { }
interface I2<out T> { }
interface I3<in T1, out T2> : I1<T1>, I2<T2> { }
interface I4<in T3, T4> where T3 : C1 { I4<T3, T4> M(I4<C1, T4> x); }

class C1 { }

class C2 : C1
{
    dynamic x1;
    sbyte x2;
    C1[] x3;
    C2[] x4;
    Array x5;
    IList<C1> x6;
    IList<C2> x7;
    Action<int> x8;
    Delegate x9;
    I1<C1> x10;
    I1<C2> x11;
    I2<C1> x12;
    I2<C2> x13;
    I3<C2, C1> x14;
    I3<C1, C2> x15;

    // Verify conversions
    void M<T3, T4, T5, T6, T7>(T3 p1, T4 p2, T5 p3, T6 p4, T7 p5)
      where T3 : I1<C1>
      where T4 : C2
      where T5 : class
      where T6 : T3
      where T7 : struct
    {
        x1 = x2;
        x3 = x4;
        x5 = x3;
        x6 = x4;
        x7 = x4;
        x9 = x8;
        x11 = x10;
        x12 = x13;
        x14 = x15;
        x11 = x14;
        x11 = p1;
        C1 c1 = p2;
        object o = p1;
        o = p2;
        o = p3;
        o = p4;
        o = p5;
        x11 = p4;
        o = null;
        int? i = null;
        p3 = null;
        o = x10;
        ValueType vt = p5;

        Func<T3, T4, T5, T6, string> x16 = null;
        Func<T3, T4, T5, T6, object> x17 = null;
        Func<T3, T4, object, T5, T6> x18 = null;
        Func<T3, T4, string, T5, T6> x19 = null;
        x17 = x16;
        x19 = x18;

        Func<I1<C1>> x20 = null;
        Func<object> x21 = null;
        Func<T3> x22 = null;
        Func<T6> x23 = null;
        x21 = x20;
        //x20 = x22; not possible even though T3 : I1<C1> (boxing conversion)
        //x22 = x23; not possible even though T6 : T3 (boxing conversion)

        T3[] x24 = null;
        T4[] x25 = null;
        object[] x26;
        //x26 = x24; not possible (boxing conversion)
        x26 = x25;

        IEnumerable<T3> x27 = null;
        IEnumerable<T4> x28 = null;
        IEnumerable<object> x29;
        //x29 = x27; not possible (boxing conversion)
        x29 = x28;
    }
}

class C3<T5, T6> where T5 : C1
{
    public I4<T5, T6> M(I4<C1, T6> x) => x;
}
