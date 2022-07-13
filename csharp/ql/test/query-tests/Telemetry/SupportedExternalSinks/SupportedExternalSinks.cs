using System;
using System.Web;

public class SupportedExternalSinks
{
    public void M1()
    {
        var o = new object();
        var response = new HttpResponse();
        response.AddHeader("header", "value");
        response.AppendHeader("header", "value");
        response.Write(o); // Known sink.
        response.WriteFile("filename"); // Known sink.
        response.Write(o); // Known sink.
    }
}
