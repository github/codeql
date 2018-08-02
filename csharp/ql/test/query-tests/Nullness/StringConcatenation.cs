using System;

class StringsTest
{
    void StringAdded()
    {
        string s = null;
        s += "abc";
        s = s.Trim(); // OK
    }

    void StringMaybeNull()
    {
        string s = null;
        while (s != "")
            s = s.Trim(); // Maybe null
    }

    void StringNotNull()
    {
        string s = null;
        while (s != "")
            s += "abc";
        s = s.Trim(); // OK (s == "")
    }

    void StringNotAssignedNull()
    {
        string s = "abc";
        s += null;
        s = s.Trim(); // OK
    }
}
