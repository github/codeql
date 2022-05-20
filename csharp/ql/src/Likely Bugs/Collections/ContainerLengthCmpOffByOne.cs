using System.IO;
using System;

class ContainerLengthOffByOne
{
    public static boolean BadContains(string searchName, string names)
    {
        string[] values = names.Split(',');
        // BAD: index could be equal to length
        for (int i = 0; i <= values.Length; i++)
        {
            // When i = length, this access will be out of bounds
            if (values[i] == searchName)
            {
                return true;
            }
        }
    }

    public static boolean GoodContains(string searchName, string names)
    {
        string[] values = names.Split(',');
        // GOOD: Avoid using indexes, and use foreach instead
        foreach (string name in values)
        {
            if (name == searchName)
            {
                return true;
            }
        }
    }
}
