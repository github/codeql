class FoldedLiterals
{
    void Test()
    {
        // Bool
        bool b1 = false;
        bool b2 = !false;

        // Char
        char c0 = ' ';
        int c1 = +' ';
        int c2 = -
              ' ';
        int c3 = ~' ';
        char c4 = '\\';

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
        int i0 = 5;
        int i1 = +5;
        int i2 = -5;
        int i3 = ~5;

        // UInt
        uint ui0 = 6;
        int ui1 = +6;
        int ui2 = -6;
        int ui3 = ~6;

        // Long
        long l0 = 7L;
        long l1 = +7L; ;
        long l2 = -7L;
        long l3 = ~7L;

        // ULong
        ulong ul0 = 8ul;
        ulong ul1 = +8ul;
        ulong ul3 = ~8ul;

        // Float
        float f0 = 9.0f;
        float f1 = +9.0f;
        float f2 = -9.0f;

        // Double
        double d0 = 10.0d;
        double d1 = +10.0d;
        double d2 = -10.0d;

        // Decimal
        decimal m0 = 11m;
        decimal m1 = +11m;
        decimal m2 = -11m;
    }
}
