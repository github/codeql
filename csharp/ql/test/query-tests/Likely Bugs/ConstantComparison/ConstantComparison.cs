using System;

class Test
{
    char charValue;
    byte byteValue;
    sbyte sbyteValue;
    short shortValue;
    ushort ushortValue;
    int intValue;
    uint uintValue;
    long longValue;
    ulong ulongValue;

    void f()
    {
        bool good, bad;

        bad = uintValue < 0;
        bad = 0 > uintValue;
        bad = 0 <= uintValue;
        bad = uintValue >= 0;

        bad = uintValue == -1;
        bad = uintValue != -1;
        bad = 256 == byteValue;
        bad = 256 != byteValue;
        bad = 1 != 0;

        good = byteValue == 50;
        good = 50 != byteValue;

        good = 1u < intValue;
        good = intValue > 1u;
        good = intValue <= 1u;
        good = 1u >= intValue;

        good = charValue >= '0';  // Regression
        good = charValue < '0';

        // Test ranges
        bad = charValue <= 65535;
        bad = charValue >= 0;

        good = charValue < 255;
        good = charValue > 0;

        bad = byteValue >= byte.MinValue;
        bad = byteValue <= byte.MaxValue;

        good = byteValue > byte.MinValue;
        good = byteValue < byte.MaxValue;

        bad = sbyteValue >= sbyte.MinValue;
        bad = sbyteValue <= sbyte.MaxValue;

        good = sbyteValue < sbyte.MaxValue;
        good = sbyteValue > sbyte.MinValue;

        bad = shortValue >= short.MinValue;
        bad = shortValue <= short.MaxValue;

        good = shortValue > short.MinValue;
        good = shortValue < short.MaxValue;

        bad = ushortValue >= ushort.MinValue;
        bad = ushortValue <= ushort.MaxValue;

        good = ushortValue > ushort.MinValue;
        good = ushortValue < ushort.MaxValue;

        bad = intValue >= int.MinValue;
        bad = intValue <= int.MaxValue;

        good = intValue > int.MinValue;
        good = intValue < int.MaxValue;

        bad = uintValue >= uint.MinValue;
        good = uintValue > uint.MinValue;

        bad = ulongValue >= ulong.MinValue;
        good = ulongValue > ulong.MinValue;

        // Explicit casts can cause large values to be truncated or
        // to wrap into negative values.
        good = (sbyte)byteValue >= 0;
        good = (sbyte)byteValue == -1;
        bad = (sbyte)byteValue > 127;
        bad = (sbyte)byteValue > (sbyte)127;
        good = (int)uintValue == -1;
        good = (sbyte)uintValue == -1;
        bad = (sbyte)uintValue == 256;

        System.Diagnostics.Debug.Assert(ulongValue >= ulong.MinValue);  // GOOD
    }
}
