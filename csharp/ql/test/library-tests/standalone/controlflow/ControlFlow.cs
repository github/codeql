using System;

class Cfg
{
    void F()
    {
        var v = new InvalidType();
        Debug.Assert(v.a.b, "This is true");

        new CounterCreationData() { CounterHelp = string.Empty, CounterType = v.Type };
    }
}
