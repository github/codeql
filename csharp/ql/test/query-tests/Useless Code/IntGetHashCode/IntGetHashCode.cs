class IntGetHashCode
{
    void Test()
    {
        // These are all bad:
        default(int).GetHashCode(); // $ Alert
        default(short).GetHashCode(); // $ Alert
        default(ushort).GetHashCode(); // $ Alert
        default(byte).GetHashCode(); // $ Alert
        default(sbyte).GetHashCode(); // $ Alert

        // These are all good:
        default(uint).GetHashCode();
        default(long).GetHashCode();
        default(ulong).GetHashCode();
        default(double).GetHashCode();
        default(float).GetHashCode();
        default(char).GetHashCode();
        default(string).GetHashCode();
        default(object).GetHashCode();
    }
}
