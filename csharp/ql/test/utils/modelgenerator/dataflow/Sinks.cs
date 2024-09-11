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
    public static void Sink(object o) => throw null;

    // Sink defined in the extensible file next to the test.
    // neutral=Sinks;NewSinks;Sink2;(System.Object);summary;df-generated
    public static void Sink2(object o) => throw null;

    // Defined as sink neutral in the file next to the neutral summary test.
    // neutral=Sinks;NewSinks;NoSink;(System.Object);summary;df-generated
    public static void NoSink(object o) => throw null;

    // Sink and Source defined in the extensible file next to the sink test.
    // sink=Sinks;NewSinks;false;SaveAndGet;(System.Object);;Argument[0];test-sink;df-generated
    // neutral=Sinks;NewSinks;SaveAndGet;(System.Object);summary;df-generated
    public static object SaveAndGet(object o)
    {
        Sink(o);
        return null;
    }

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

    public abstract class DataWriter
    {
        // neutral=Sinks;NewSinks+DataWriter;Write;(System.Object);summary;df-generated
        public abstract void Write(object o);
    }

    public class DataWriterKind1 : DataWriter
    {
        // sink=Sinks;NewSinks+DataWriterKind1;true;Write;(System.Object);;Argument[0];test-sink;df-generated
        // neutral=Sinks;NewSinks+DataWriterKind1;Write;(System.Object);summary;df-generated
        public override void Write(object o)
        {
            Sink(o);
        }
    }

    public class DataWriterKind2 : DataWriter
    {
        // sink=Sinks;NewSinks+DataWriterKind2;true;Write;(System.Object);;Argument[0];test-sink2;df-generated
        // neutral=Sinks;NewSinks+DataWriterKind2;Write;(System.Object);summary;df-generated
        public override void Write(object o)
        {
            Sink2(o);
        }
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
