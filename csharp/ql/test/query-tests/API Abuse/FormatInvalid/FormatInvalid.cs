using System;
using System.Text;

class FormatInvalid
{
    void FormatStringTests()
    {
        // GOOD: Valid format string
        String.Format("{0}", 1);

        // GOOD: Valid format string
        String.Format("{0,1}", 1);

        // GOOD: Valid format string
        String.Format("{0,  1}", 1);

        // GOOD: Valid format string
        String.Format("{0,-1}", 1);

        // GOOD: Valid format string
        String.Format("{0:0.000}", 1);

        // GOOD: Valid format string
        String.Format("{0, -10 :0.000}", 1);

        // BAD: Invalid format string
        String.Format("{ 0}", 1); // $ Alert

        // BAD: Invalid format string
        String.Format("{0,--1}", 1); // $ Alert

        // BAD: Invalid format string
        String.Format("{0:{}}", 1); // $ Alert

        // BAD: Invalid format string
        String.Format("%d", 1); // $ Alert Sink

        // BAD: } { in the middle.
        String.Format("{{0}-{1}}", 0, 1); // $ Alert

        // BAD: This is invalid
        String.Format("{0}}", 0, 1); // $ Alert

        // BAD: Invalid
        string.Format("{foo{0}}", 0); // $ Alert

        // GOOD: {{ is output as {
        String.Format("{{sdc}}{0}", 0);

        // BAD: Invalid: Stray }
        String.Format("}{0}", 0); // $ Alert

        // GOOD: {{ output as {
        String.Format("new {0} ({1} => {{", 0, 1);

        // GOOD: Literal {{ and }}
        String.Format("{0}{{", 0);
        String.Format("{0}{{{{}}", 0);
    }

    IFormatProvider fp;
    object[] ps;
    StringBuilder sb;
    System.IO.TextWriter tw;
    System.Diagnostics.TraceSource ts;

    void Format(String str, Object obj) { }

    void FormatMethodTests()
    {
        // GOOD: Not a recognised format method.
        Format("}", 0);

        // BAD: All of these are format methods with an invalid string.
        String.Format("}"); // $ Alert
        String.Format("}", 0); // $ Alert
        String.Format("}", ps); // $ Alert
        String.Format(fp, "}", ps); // $ Alert
        String.Format("}", 0, 1); // $ Alert
        String.Format("}", 0, 1, 2); // $ Alert
        String.Format("}", 0, 1, 2, 3); // $ Alert

        sb.AppendFormat("}"); // $ Alert
        sb.AppendFormat("}", 0); // $ Alert
        sb.AppendFormat("}", ps); // $ Alert
        sb.AppendFormat(fp, "}", ps); // $ Alert
        sb.AppendFormat("}", 0, 1); // $ Alert
        sb.AppendFormat("}", 0, 1, 2); // $ Alert
        sb.AppendFormat("}", 0, 1, 2, 3); // $ Alert

        Console.WriteLine("}", 0); // $ Alert
        Console.WriteLine("}", ps); // $ Alert
        Console.WriteLine("}", 0, 1); // $ Alert
        Console.WriteLine("}", 0, 1, 2); // $ Alert
        Console.WriteLine("}", 0, 1, 2, 3); // $ Alert

        tw.WriteLine("}", 0); // $ Alert
        tw.WriteLine("}", ps); // $ Alert
        tw.WriteLine("}", 0, 1); // $ Alert
        tw.WriteLine("}", 0, 1, 2); // $ Alert
        tw.WriteLine("}", 0, 1, 2, 3); // $ Alert

        System.Diagnostics.Debug.WriteLine("}", ps); // $ Alert
        System.Diagnostics.Trace.TraceError("}", 0); // $ Alert
        System.Diagnostics.Trace.TraceInformation("}", 0); // $ Alert
        System.Diagnostics.Trace.TraceWarning("}", 0); // $ Alert
        ts.TraceInformation("}", 0); // $ Alert

        Console.Write("}", 0); // $ Alert
        Console.Write("}", 0, 1); // $ Alert
        Console.Write("}", 0, 1, 2); // $ Alert
        Console.Write("}", 0, 1, 2, 3); // $ Alert

        System.Diagnostics.Debug.WriteLine("}", ""); // GOOD
        System.Diagnostics.Debug.Write("}", "");     // GOOD

        System.Diagnostics.Debug.Assert(true, "Error", "}", ps); // $ Alert
        sw.Write("}", 0); // $ Alert
        System.Diagnostics.Debug.Print("}", ps); // $ Alert

        Console.WriteLine("}"); // GOOD

        // The Following methods are not recognised as format methods.
        Console.WriteLine("{0}"); // GOOD
        Console.Write("{0}"); // GOOD
        tw.WriteLine("{0}"); // GOOD
        tw.Write("{0}"); // GOOD
        System.Diagnostics.Debug.Print("{0}"); // GOOD
        System.Diagnostics.Debug.WriteLine("{0}"); // GOOD
        System.Diagnostics.Debug.Write("{0}");     // GOOD
        System.Diagnostics.Trace.TraceError("{0}"); // GOOD
        System.Diagnostics.Trace.TraceInformation("{0}"); // GOOD
        System.Diagnostics.Trace.TraceWarning("{0}"); // GOOD
        ts.TraceInformation("{0}"); // GOOD
    }

    System.IO.StringWriter sw;
}
