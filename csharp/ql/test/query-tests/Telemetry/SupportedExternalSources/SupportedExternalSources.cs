using System;

public class SupportExternalSources
{
    public void M1()
    {
        var l1 = Console.ReadLine(); // Known source.
        var l2 = Console.ReadLine(); // Known source.
        Console.SetError(Console.Out);
        var x = Console.Read(); // Know source.
    }
}
