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
        d = 1 / 2;
        f = 1 / 2;
        d = -1 / 2;
        f = -2 / 3;
        d = x / y;
        f = x / y;
        d = x / 2;
        d = 4 / y;
        d = 1.0 + 1 / 2;
        d = 2.0 * (1 / 2);
        d = 1 + 1 / 2 + 4 / 2;
        d = 1 * (1 / 2);

        // These are GOOD:
        d = 4 / 2;
        d = 1 / 2.0;
        i = 5 / 10;

        // These are BAD:
        dec = 2 * i + 1;
        dec = unchecked(int.MaxValue * int.MaxValue);

        // These are GOOD:
        dec = 2 * (uint)int.MaxValue - 1;
        dec = 2m * i + 1;
    }
}
