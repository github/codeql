using System;

class C
{
    sbyte xsbyte;
    byte xbyte;
    short xshort;
    ushort xushort;
    int xint;
    uint xuint;
    long xlong;
    ulong xulong;
    char xchar;
    float xfloat;
    double xdouble;
    decimal xdecimal;

    // Verify conversions
    void M()
    {
        xshort = xsbyte;
        xint = xsbyte;
        xlong = xsbyte;
        xfloat = xsbyte;
        xdouble = xsbyte;
        xdecimal = xsbyte;

        xshort = xbyte;
        xushort = xbyte;
        xint = xbyte;
        xuint = xbyte;
        xlong = xbyte;
        xulong = xbyte;
        xfloat = xbyte;
        xdouble = xbyte;
        xdecimal = xbyte;

        xint = xshort;
        xlong = xshort;
        xfloat = xshort;
        xdouble = xshort;
        xdecimal = xshort;

        xint = xushort;
        xuint = xushort;
        xlong = xushort;
        xulong = xushort;
        xfloat = xushort;
        xdouble = xushort;
        xdecimal = xushort;

        xlong = xint;
        xfloat = xint;
        xdouble = xint;
        xdecimal = xint;

        xlong = xuint;
        xulong = xuint;
        xfloat = xuint;
        xdouble = xuint;
        xdecimal = xuint;

        xfloat = xlong;
        xdouble = xlong;
        xdecimal = xlong;

        xfloat = xulong;
        xdouble = xulong;
        xdecimal = xulong;

        xushort = xchar;
        xint = xchar;
        xuint = xchar;
        xlong = xchar;
        xulong = xchar;
        xfloat = xchar;
        xdouble = xchar;
        xdecimal = xchar;
    }
}
