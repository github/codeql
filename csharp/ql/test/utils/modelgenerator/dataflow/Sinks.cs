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
    // sink=Sinks;NewSinks;false;WrapResponseWrite;(System.Object);;Argument[0];html-injection;df-generated
    // neutral=Sinks;NewSinks;WrapResponseWrite;(System.Object);summary;df-generated
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
    // sink=Sinks;NewSinks;false;WrapResponseWriteFile;(System.String);;Argument[0];html-injection;df-generated
    // neutral=Sinks;NewSinks;WrapResponseWriteFile;(System.String);summary;df-generated
    public void WrapResponseWriteFile(string s)
    {
        var response = new HttpResponse();
        response.WriteFile(s);
    }

    // New sink
    // sink=Sinks;NewSinks;false;WrapFieldResponseWriteFile;();;Argument[this];html-injection;df-generated
    // neutral=Sinks;NewSinks;WrapFieldResponseWriteFile;();summary;df-generated
    public void WrapFieldResponseWriteFile()
    {
        var response = new HttpResponse();
        response.WriteFile(tainted);
    }

    // NOT new sink as field is private
    // neutral=Sinks;NewSinks;WrapPrivateFieldResponseWriteFile;();summary;df-generated
    public void WrapPrivateFieldResponseWriteFile()
    {
        var response = new HttpResponse();
        response.WriteFile(privateTainted);
    }

    // New sink
    // sink=Sinks;NewSinks;false;WrapPropResponseWriteFile;();;Argument[this];html-injection;df-generated
    // neutral=Sinks;NewSinks;WrapPropResponseWriteFile;();summary;df-generated
    public void WrapPropResponseWriteFile()
    {
        var response = new HttpResponse();
        response.WriteFile(TaintedProp);
    }

    // NOT new sink as property is private
    // neutral=Sinks;NewSinks;WrapPrivatePropResponseWriteFile;();summary;df-generated
    public void WrapPrivatePropResponseWriteFile()
    {
        var response = new HttpResponse();
        response.WriteFile(PrivateTaintedProp);
    }

    // NOT new sink as property setter is private
    // neutral=Sinks;NewSinks;WrapPropPrivateSetResponseWriteFile;();summary;df-generated
    public void WrapPropPrivateSetResponseWriteFile()
    {
        var response = new HttpResponse();
        response.WriteFile(PrivateSetTaintedProp);
    }
}
