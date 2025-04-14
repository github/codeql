using System;

public class TestClass
{
    public void M()
    {
        var x1 = "Hello world";
        var x2 = "\u001b";
        var x3 = "\x1b";
        var x4 = "\e";
    }
}
