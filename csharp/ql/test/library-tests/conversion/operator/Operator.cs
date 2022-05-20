using System;

class C
{
    public static implicit operator C(int i) { return null; }

    int x1;
    C x2;

    // Verify conversions
    void M()
    {
        x2 = x1;
    }
}
