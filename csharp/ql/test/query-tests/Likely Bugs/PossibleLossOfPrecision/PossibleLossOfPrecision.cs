class Program
{
    static int x;
    static char y;

    static void main(string[] args)
    {
        double d;
        float f;
        int i;
        decimal dec;

        // These are BAD:
        d = 1 / 2; // $ Alert
        f = 1 / 2; // $ Alert
        d = -1 / 2; // $ Alert
        f = -2 / 3; // $ Alert
        d = x / y; // $ Alert
        f = x / y; // $ Alert
        d = x / 2; // $ Alert
        d = 4 / y; // $ Alert
        d = 1.0 + 1 / 2; // $ Alert
        d = 2.0 * (1 / 2); // $ Alert
        d = 1 + 1 / 2 + 4 / 2; // $ Alert
        d = 1 * (1 / 2); // $ Alert

        // These are GOOD:
        d = 4 / 2;
        d = 1 / 2.0;
        i = 5 / 10;

        // These are BAD:
        dec = 2 * i + 1; // $ Alert
        dec = unchecked(int.MaxValue * int.MaxValue); // $ Alert

        // These are GOOD:
        dec = 2 * (uint)int.MaxValue - 1;
        dec = 2m * i + 1;
    }
}
