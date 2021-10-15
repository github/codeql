class IntGetHashCode
{
    void Test()
    {
        // These are all bad:
        default(uint).GetHashCode();
        default(int).GetHashCode();
        default(long).GetHashCode();
        default(ulong).GetHashCode();
        default(short).GetHashCode();
        default(ushort).GetHashCode();
        default(byte).GetHashCode();
        default(sbyte).GetHashCode();

        // These are all good:
        default(double).GetHashCode();
        default(float).GetHashCode();
        default(char).GetHashCode();
        default(string).GetHashCode();
        default(object).GetHashCode();
    }
}
