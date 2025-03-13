class IntGetHashCode
{
    void Test()
    {
        // These are all bad:
        default(uint).GetHashCode(); // $ Alert
        default(int).GetHashCode(); // $ Alert
        default(long).GetHashCode(); // $ Alert
        default(ulong).GetHashCode(); // $ Alert
        default(short).GetHashCode(); // $ Alert
        default(ushort).GetHashCode(); // $ Alert
        default(byte).GetHashCode(); // $ Alert
        default(sbyte).GetHashCode(); // $ Alert

        // These are all good:
        default(double).GetHashCode();
        default(float).GetHashCode();
        default(char).GetHashCode();
        default(string).GetHashCode();
        default(object).GetHashCode();
    }
}
