class FoldedLiterals
{
    void Test()
    {
        // Bool
        bool b2 = !false;

        // Char
        int c1 = +'\\';
        int c2 = -' ';
        int c3 = ~' ';

        // SByte
        sbyte sb0 = (sbyte)1;
        int sb1 = +(sbyte)1;
        int sb2 = -(sbyte)1;
        int sb3 = ~(sbyte)1;

        // Byte
        byte ub0 = (byte)2;
        int ub1 = +(byte)2;
        int ub2 = -(byte)2;
        int ub3 = ~(byte)2;

        // Short
        short ss0 = (short)3;
        int ss1 = +(short)3;
        int ss2 = -(short)3;
        int ss3 = ~(short)3;

        // UShort
        ushort us0 = (ushort)4;
        int us1 = +(ushort)4;
        int us2 = -(ushort)4;
        int us3 = ~(ushort)4;

        // Int
        int i1 = +(5 + 5);
        int i2 = -5;
        int i3 = ~5;

        // UInt
        uint ui1 = +(6u + 6u);

        uint ui3 = ~6u;

        // Long
        long l1 = +(7L + 7L);
        long l2 = -7L;
        long l3 = ~7L;

        // ULong
        ulong ul1 = +(8ul + 8ul);
        ulong ul3 = ~8ul;

        // Float
        float f1 = +(9.0f + 9.0f);
        float f2 = -9.0f;

        // Double
        double d1 = +(10.0d + 10.0d);
        double d2 = -10.0d;

        // Decimal
        decimal m1 = +(11m + 11m);
        decimal m2 = -11m;
    }
}
