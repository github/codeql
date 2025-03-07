class Test
{
    static void Main(string[] args)
    {
        // BAD
        c3.Equals(c4);
        c2.Equals(c3);
        c7.Equals(c6);

        // GOOD
        c1.Equals(c2);
        c1.Equals(c1);
        c1.Equals(o);
        c1.Equals(i1);
        c4.Equals(c5);
    }

    C1 c1;
    C2 c2;
    C3 c3;
    C4 c4;
    C5 c5;
    C6 c6;
    C7 c7;
    object o;
    I1 i1;
}

class C1
{
}

class C2 : C1
{
}

class C3 : C1
{
}

class C4
{
}

class C5 : NoSuchClass
{
}

class C6 : C5
{
}

class C7 : C5
{
}

interface I1
{
}
