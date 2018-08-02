class Complex
{
    static bool foo(bool a, bool b, bool c, bool d, bool e, bool f, bool g)
    {
        bool x = a || b || c || d || e || f || g; // OK
        bool y = a && b || !(b && c) || !(d && e) && !(f && g); // NOT OK
        bool z = (a && b || (b && c)) && ((d && e) || (f && g)); // NOT OK
        return x && y && z; // OK
    }
}
