class EqualsArrayFix
{
    static bool DeepEquals<T>(T[] arr1, T[] arr2)
    {
        // If arr1 and arr2 refer to the same array, they are trivially equal.
        if (ReferenceEquals(arr1, arr2)) return true;

        // If either arr1 or arr2 is null and they are not both null (see the previous
        // check), they are not equal.
        if (arr1 == null || arr2 == null) return false;

        // If both arrays are non-null but have different lengths, they are not equal.
        if (arr1.Length != arr2.Length) return false;

        // Failing which, do an element-by-element compare.
        for (int i = 0; i < arr1.Length; ++i)
        {
            // Early out if we find corresponding array elements that are not equal.
            if (!arr1[i].Equals(arr2[i])) return false;
        }

        // If we get here, all of the corresponding array elements were equal, so the
        // arrays are equal.
        return true;
    }

    public static void Main(string[] args)
    {
        string[] strings = { "hello", "world" };
        string[] moreStrings = { "hello", "world" };
        Console.WriteLine(strings.SequenceEqual(moreStrings));
        Console.WriteLine(DeepEquals(strings, moreStrings));
    }
}
