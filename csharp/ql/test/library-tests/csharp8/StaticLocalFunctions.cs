// semmle-extractor-options: /langversion:8.0

using System;

class StaticLocalFunctions
{
    int Fn(int x)
    {
        static int I(int y) => y;
        int J(int y) => x+y;
        return I(x) + J(x);
    }
}
