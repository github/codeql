public struct S1 { }
public ref struct S2 { }

// The `scoped` modifier can be applied to parameters
// or local variables. The type of the parameter or
// local variable must be either a `ref` value or `ref struct` value.
public class ScopedModifierTest
{
    public ref int M1(scoped ref int x1, ref int y1)
    {
        // Not allowed.
        // return ref x1;
        return ref y1;
    }

    public ref int M2(scoped out int x2, ref int y2)
    {
        x2 = 0;
        // Not allowed.
        // return ref x;
        return ref y2;
    }

    public int M3(scoped ref int x3)
    {
        // Allowed is it is not returned by reference.
        return x3;
    }

    public S1 M4(scoped ref S1 x4)
    {
        // Allowed as it is not returned by reference.
        return x4;
    }

    public S2 M5(scoped S2 x5)
    {
        // Not allowed.
        // return x5;
        return new S2();
    }

    public S2 M6(scoped ref S2 x6)
    {
        // Not allowed.
        // return x6;
        return new S2();
    }

    public S2 Locals()
    {
        scoped S2 x7 = new S2();
        // Not allowed.
        // return x7;
        S2 y7 = new S2();
        return y7;
    }

}