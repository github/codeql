enum E
{
    A
}

class EnumTest
{
    void M()
    {
        // enums are modelled as fields; this test checks that we do not compute SSA for them
        var e1 = E.A;
        var e2 = E.A;
    }
}
