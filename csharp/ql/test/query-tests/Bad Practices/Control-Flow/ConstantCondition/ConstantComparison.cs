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

        bad = uintValue < 0; // $ Alert
        bad = 0 > uintValue; // $ Alert
        bad = 0 <= uintValue; // $ Alert
        bad = uintValue >= 0; // $ Alert

        bad = uintValue == -1; // $ Alert
        bad = uintValue != -1; // $ Alert
        bad = 256 == byteValue; // $ Alert
        bad = 256 != byteValue; // $ Alert
        bad = 1 != 0; // $ Alert

        good = byteValue == 50;
        good = 50 != byteValue;

        good = 1u < intValue;
        good = intValue > 1u;
        good = intValue <= 1u;
        good = 1u >= intValue;

        good = charValue >= '0';
        good = charValue < '0';

        // Test ranges
        bad = charValue <= 65535; // $ Alert
        bad = charValue >= 0; // $ Alert

        good = charValue < 255;
        good = charValue > 0;

        bad = byteValue >= byte.MinValue; // $ Alert
        bad = byteValue <= byte.MaxValue; // $ Alert

        good = byteValue > byte.MinValue;
        good = byteValue < byte.MaxValue;

        bad = sbyteValue >= sbyte.MinValue; // $ Alert
        bad = sbyteValue <= sbyte.MaxValue; // $ Alert

        good = sbyteValue < sbyte.MaxValue;
        good = sbyteValue > sbyte.MinValue;

        bad = shortValue >= short.MinValue; // $ Alert
        bad = shortValue <= short.MaxValue; // $ Alert

        good = shortValue > short.MinValue;
        good = shortValue < short.MaxValue;

        bad = ushortValue >= ushort.MinValue; // $ Alert
        bad = ushortValue <= ushort.MaxValue; // $ Alert

        good = ushortValue > ushort.MinValue;
        good = ushortValue < ushort.MaxValue;

        bad = intValue >= int.MinValue; // $ Alert
        bad = intValue <= int.MaxValue; // $ Alert

        good = intValue > int.MinValue;
        good = intValue < int.MaxValue;

        bad = uintValue >= uint.MinValue; // $ Alert
        good = uintValue > uint.MinValue;

        bad = ulongValue >= ulong.MinValue; // $ Alert
        good = ulongValue > ulong.MinValue;

        // Explicit casts can cause large values to be truncated or
        // to wrap into negative values.
        good = (sbyte)byteValue >= 0;
        good = (sbyte)byteValue == -1;
        bad = (sbyte)byteValue > 127; // $ Alert
        bad = (sbyte)byteValue > (sbyte)127; // $ Alert
        good = (int)uintValue == -1;
        good = (sbyte)uintValue == -1;
        bad = (sbyte)uintValue == 256; // $ Alert

        System.Diagnostics.Debug.Assert(ulongValue >= ulong.MinValue);  // GOOD
    }
}
