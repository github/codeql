using System;

class C
{
    sbyte x1;
    sbyte? x2;
    Nullable<int> x3;
    Nullable<char> x4;

    // Verify conversions
    void M()
    {
        x2 = x1;
        x3 = x4;
    }

    // Cause the following types to exist in the database:
    byte? x5;
    short? x6;
    ushort? x7;
    uint? x8;
    ulong? x9;
    decimal? x10;
    double? x11;
    long? x12;
    float? x13;
}
