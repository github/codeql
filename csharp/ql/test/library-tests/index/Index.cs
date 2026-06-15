using System;

public class Container
{
    public object[] Buffer { get; } = new object[10];
}

public class TestIndex
{
    public void M()
    {
        var c = new Container()
        {
            Buffer =
            {
                [0] = new object(),
                [1] = new object(),
                [^1] = new object()
            }
        };
        c.Buffer[4] = new object();
        c.Buffer[^3] = new object();
    }
}
