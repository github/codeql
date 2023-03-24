using System;
using System.Web;

namespace Sinks;

public class NewSinks
{
    private string privateTainted;
    public string tainted;

    private string PrivateTaintedProp { get; set; }
    public string TaintedProp { get; set; }
    public string PrivateSetTaintedProp { get; private set; }

    // New sink
    public void WrapResponseWrite(object o)
    {
        var response = new HttpResponse();
        response.Write(o);
    }

    // NOT new sink as method is private
    private void PrivateWrapResponseWrite(object o)
    {
        var response = new HttpResponse();
        response.Write(o);
    }

    // New sink
    public void WrapResponseWriteFile(string s)
    {
        var response = new HttpResponse();
        response.WriteFile(s);
    }

    // New sink
    public void WrapFieldResponseWriteFile()
    {
        var response = new HttpResponse();
        response.WriteFile(tainted);
    }

    // NOT new sink as field is private
    public void WrapPrivateFieldResponseWriteFile()
    {
        var response = new HttpResponse();
        response.WriteFile(privateTainted);
    }

    // New sink
    public void WrapPropResponseWriteFile()
    {
        var response = new HttpResponse();
        response.WriteFile(TaintedProp);
    }

    // NOT new sink as property is private
    public void WrapPrivatePropResponseWriteFile()
    {
        var response = new HttpResponse();
        response.WriteFile(PrivateTaintedProp);
    }

    // NOT new sink as property setter is private
    public void WrapPropPrivateSetResponseWriteFile()
    {
        var response = new HttpResponse();
        response.WriteFile(PrivateSetTaintedProp);
    }
}