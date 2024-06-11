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

    // Sink defined in the extensible file next to the test.
    // neutral=Sinks;NewSinks;Sink;(System.Object);summary;df-generated
    public void Sink(object o) => throw null;

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

    // Not a new sink because a simple type is used in an intermediate step
    // neutral=Sinks;NewSinks;WrapResponseWriteFileSimpleType;(System.String);summary;df-generated
    public void WrapResponseWriteFileSimpleType(string s)
    {
        var r = s == "hello";
        Sink(r);
    }

    // Not a new sink as this callable has been manually modelled
    // as sink neutral.
    // neutral=Sinks;NewSinks;ManualSinkNeutral;(System.Object);summary;df-generated
    public void ManualSinkNeutral(object o)
    {
        Sink(o);
    }

    // Not a new sink as this callable already has a manual sink.
    // neutral=Sinks;NewSinks;ManualSinkAlreadyDefined;(System.Object);summary;df-generated
    public void ManualSinkAlreadyDefined(object o)
    {
        Sink(o);
    }
}

public class CompoundSinks
{
    // neutral=Sinks;CompoundSinks;WrapNewSinkProp;(Sinks.NewSinks);summary;df-generated
    // sink=Sinks;CompoundSinks;false;WrapNewSinkProp;(Sinks.NewSinks);;Argument[0];html-injection;df-generated
    public void WrapNewSinkProp(NewSinks ns)
    {
        ns.WrapPropResponseWriteFile();
    }

    // neutral=Sinks;CompoundSinks;WrapNewSinkField;(Sinks.NewSinks);summary;df-generated
    // sink=Sinks;CompoundSinks;false;WrapNewSinkField;(Sinks.NewSinks);;Argument[0];html-injection;df-generated
    public void WrapNewSinkField(NewSinks ns)
    {
        ns.WrapFieldResponseWriteFile();
    }
}
