using System;

class StringsTest
{
    void StringAdded()
    {
        string s = null;
        s += "abc";
        s = s.Trim(); // GOOD
    }

    void StringMaybeNull()
    {
        string s = null;
        while (s != "")
            s = s.Trim(); // BAD (maybe)
    }

    void StringNotNull()
    {
        string s = null;
        while (s != "")
            s += "abc";
        s = s.Trim(); // GOOD
    }

    void StringNotAssignedNull()
    {
        string s = "abc";
        s += null;
        s = s.Trim(); // GOOD
    }
}
