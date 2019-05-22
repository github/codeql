using System;

class StaticLocalFunction
{
    int F()
    {
        static int G(int x) => x;
        return G(12);
    }
}
