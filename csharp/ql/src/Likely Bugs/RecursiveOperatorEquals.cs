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
        // Both of these checks against null call operator== recursively.
        // They were probably intended to be checks for reference equality.
        if (lhs == null || rhs == null)
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
