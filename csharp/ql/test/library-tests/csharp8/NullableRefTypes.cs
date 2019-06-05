using System;

class NullableRefTypes
{
    void TestNullableRefTypes()
    {
        string? x = "source";
        string y = x!;
        y = x!!;
    }
}
