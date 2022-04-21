using System;
using System.Collections.Generic;

public class LibraryUsage
{
    public void M1()
    {
        var l = new List<object>(); // Uninteresting parameterless constructor
        var o = new object(); // Uninteresting parameterless constructor
        l.Add(o); // Has flow summary
        l.Add(o); // Has flow summary
    }

    public void M2()
    {
        var d0 = new DateTime(); // Uninteresting parameterless constructor
        var next0 = d0.AddYears(30); // Has no flow summary

        var d1 = new DateTime(2000, 1, 1); // Interesting constructor
        var next1 = next0.AddDays(3); // Has no flow summary
        var next2 = next1.AddYears(5); // Has no flow summary
    }

    public void M3()
    {
        var guid1 = Guid.Parse("{12345678-1234-1234-1234-123456789012}"); // Has no flow summary
    }
}
