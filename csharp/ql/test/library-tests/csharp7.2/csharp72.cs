using System;

class InModifiers
{
    struct S
    {
    }

    void F(in S s)
    {
    }

    void CallF()
    {
      var s = new S();
      F(in s);
    }
}

class RefReadonlyReturns
{
    int s;

    ref readonly int F()
    {
        return ref s;
    }

    delegate ref readonly int Del();
}

readonly struct ReadonlyStruct
{
}

ref struct RefStruct
{
}

readonly ref struct ReadonlyRefStruct
{
}

class NumericLiterals
{
    int binaryValue = 0b_0101_0101;
}

class PrivateProtected
{
    private protected int X = 1;

    private protected void F() { }
}
