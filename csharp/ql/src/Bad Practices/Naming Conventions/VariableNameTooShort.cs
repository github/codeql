class VariableNameTooShort
{
    public static void Main(string[] args)
    {
        int q = 5;
        int s = 2;
        int x = 15;
        int qx = q * x;
        // later on in the code
        int r = q + (2 * qx) / (x + s);
    }
}
