using System;
using System.Runtime.Serialization;

class C
{
    int x1;
    int? x2;
    Nullable<int> x3;
    Nullable<char> x4;

    // Verify conversions
    void M()
    {
        x2 = x1;    // T -> T?      conversion: implicit, nullable          -> implicit cast
        x3 = x4;    // T1? -> T2?   conversion: implicit, nullable          -> implicit cast

        x12 = x1;   // T1 -> T2?    conversion: implicit, nullable          -> implicit cast
        x12 = null; // null -> T?   conversion: implicit, null literal      -> no cast

        x3 = x2;    // T? -> T?     no conversion

        x14 = x15;  // T1? -> T2?   conversion: implicit, user defined      -> implicit cast
    }

    // Cause the following types to exist in the database:
    sbyte? x0;
    byte? x5;
    short? x6;
    ushort? x7;
    uint? x8;
    ulong? x9;
    decimal? x10;
    double? x11;
    long? x12;
    float? x13;

    A? x14;
    B? x15;

    struct A
    {
    }

    struct B
    {
        public static implicit operator A(B value)
        {
            return new A();
        }
    }
}
