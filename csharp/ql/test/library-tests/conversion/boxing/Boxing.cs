using System;

enum E { }

interface I { }

class C<T1, T2, T3, T4, T5, T6>
  where T2 : class
  where T3 : struct
  where T4 : new()
  where T5 : I
  where T6 : C<T1, T2, T3, T4, T5, T6>
{
    object x1;
    dynamic x2;
    ValueType x3;
    int x4;
    IComparable<int> x5;
    Enum x6;
    E x7;
    int? x8;
    T1 x9;
    I x10;
    T2 x11;
    T3 x12;
    T4 x13;
    T5 x14;
    T6 x15;

    // Verify conversions
    void M()
    {
        x1 = x4;
        x2 = x4;
        x3 = x4;
        x5 = x4;
        x6 = x7;
        x3 = x8;
        x1 = x9;
        x1 = x10; // not a boxing conversion
        x1 = x11; // not a boxing conversion
        x1 = x12;
        x1 = x13;
        x1 = x14;
        x1 = x15; // not a boxing conversion
    }
}

// Ref structs can't be converted to a dynamic, object or valuetype.
ref struct S { }
