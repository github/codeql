using System;

class StaticFields
{
    static int staticField;
    int instanceField;

    static StaticFields()
    {
        staticField = 0;    // OK
    }

    StaticFields()
    {
        staticField = 0;    // BAD
        instanceField = 0;  // OK
    }

    static void StaticTest()
    {
        staticField = 0;    // OK
    }

    void InstanceTest()
    {
        staticField = 0;    // BAD
        instanceField = 0;  // OK
    }
}
