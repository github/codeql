class Year
{
    private int year;
    private bool bc;

    public Year(int i)
    {
        year = Math.Abs(i);
        bc = i < 0;
    }

    public static bool operator ==(Year lhs, Year rhs)
    {
        // Either of these alternative approaches works.
        if (ReferenceEquals(lhs, null) || (object)rhs == null)
        {
            return false;
        }

        return lhs.year == rhs.year && lhs.bc == rhs.bc;
    }

    public static bool operator !=(Year lhs, Year rhs)
    {
        return !(lhs == rhs);
    }
}
