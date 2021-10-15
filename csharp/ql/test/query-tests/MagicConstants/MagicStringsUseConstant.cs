using System;

public static class StringConstants
{
    const string PRIVATE_CONSTANT = "abcdefgh";
    public static readonly string PUBLIC_CONSTANT = "abcdefgh";
}

class UseConstantString
{
    const string CONSTANT = "abcdefgh";

    // GOOD: Initializers in arrays
    string[] values1 = { "abcdefgh" };

    // BAD: Use constant
    string values2 = "abcdefgh";

    void Test()
    {
        // BAD: Use constant
        var v1 = "abcdefgh";

        // GOOD: Constant used.
        var v2 = StringConstants.PUBLIC_CONSTANT;
    }
}
