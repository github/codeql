class UselessIsBeforeAs
{
    public object M(object x)
    {
        if (x is string)
        {
            M(x as string); // GOOD
            return (x as string) + " "; // BAD
        }
        else
        {
            return x as UselessIsBeforeAs; // GOOD
        }
        return null;
    }

    void M(string s) { }
}
