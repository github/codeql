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
        string s = null; // $ Source[cs/dereferenced-value-may-be-null]
        while (s != "")
            s = s.Trim(); // $ Alert[cs/dereferenced-value-may-be-null]
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
