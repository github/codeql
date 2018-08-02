class ReferenceEqualsOnValueTypes
{
    static void Main(string[] args)
    {
        int i = 17;
        int j = 17;

        bool b = ReferenceEquals(i, j);
    }
}
