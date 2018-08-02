using System;

public static class IntConstants
{
    const int PRIVATE_CONST = 241;
    public static readonly int PUBLIC_READONLY = 241;
    public const int PUBLIC_CONST = 241;
}

class UseConstantNumber
{
    const int CONSTANT = 241;

    // GOOD: Initializers in arrays
    int[] values1 = { 241 };
    byte[] values2 = { 241 };

    // BAD: Use constant
    int values3 = 241;

    void Test()
    {
        // BAD: Use constant
        var v1 = 241;

        // GOOD: Constant used
        var v2 = IntConstants.PUBLIC_CONST;
    }
}
