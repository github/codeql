using System;
using System.Collections.Generic;
using System.Web;

public class SupportedExternalApis
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
        var next0 = d0.AddYears(30); // Has no flow summary, supported as neutral summary model

        var d1 = new DateTime(2000, 1, 1); // Interesting constructor, supported as neutral summary model
        var next1 = next0.AddDays(3); // Has no flow summary, supported as neutral summary model
        var next2 = next1.AddYears(5); // Has no flow summary, supported as neutral summary model
    }

    public void M3()
    {
        var guid1 = Guid.Parse("{12345678-1234-1234-1234-123456789012}"); // Has no flow summary, supported as neutral summary model
    }

    public void M4()
    {
        var o = new object(); // Uninteresting parameterless constructor
        var response = new HttpResponse(); // Uninteresting parameterless constructor
        response.AddHeader("header", "value"); // Unsupported
        response.AppendHeader("header", "value"); // Unsupported
        response.Write(o); // Known sink
        response.WriteFile("filename"); // Known sink
        response.Write(o); // Known sink
    }

    public void M5()
    {
        var l1 = Console.ReadLine(); // Known source
        var l2 = Console.ReadLine(); // Known source
        Console.SetError(Console.Out); // Has no flow summary, supported as neutral summary model
        var x = Console.Read(); // Known source
    }

    public void M6()
    {
        var html = new HtmlString("html"); // Supported HtmlSink defined in QL.
    }
}
