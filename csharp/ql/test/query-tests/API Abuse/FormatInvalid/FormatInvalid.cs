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
        String.Format("{ 0}", 1);

        // BAD: Invalid format string
        String.Format("{0,--1}", 1);

        // BAD: Invalid format string
        String.Format("{0:{}}", 1);

        // BAD: Invalid format string
        String.Format("%d", 1);

        // BAD: } { in the middle.
        String.Format("{{0}-{1}}", 0, 1);

        // BAD: This is invalid
        String.Format("{0}}", 0, 1);

        // BAD: Invalid
        string.Format("{foo{0}}", 0);

        // GOOD: {{ is output as {
        String.Format("{{sdc}}", 0);

        // BAD: Invalid: Stray }
        String.Format("}", 0);

        // GOOD: {{ output as {
        String.Format("new {0} ({1} => {{", 0);

        // GOOD: Literal {{ and }}
        String.Format("{{", "");
        String.Format("{{{{}}", "");
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
        String.Format("}", 0);
        String.Format("}", ps);
        String.Format(fp, "}", ps);
        String.Format("}", 0, 1);
        String.Format("}", 0, 1, 2);
        String.Format("}", 0, 1, 2, 3);

        sb.AppendFormat("}", 0);
        sb.AppendFormat("}", ps);
        sb.AppendFormat(fp, "}", ps);
        sb.AppendFormat("}", 0, 1);
        sb.AppendFormat("}", 0, 1, 2);
        sb.AppendFormat("}", 0, 1, 2, 3);

        Console.WriteLine("}", 0);
        Console.WriteLine("}", ps);
        Console.WriteLine("}", 0, 1);
        Console.WriteLine("}", 0, 1, 2);
        Console.WriteLine("}", 0, 1, 2, 3);

        tw.WriteLine("}", 0);
        tw.WriteLine("}", ps);
        tw.WriteLine("}", 0, 1);
        tw.WriteLine("}", 0, 1, 2);
        tw.WriteLine("}", 0, 1, 2, 3);

        System.Diagnostics.Debug.WriteLine("}", ps);
        System.Diagnostics.Trace.TraceError("}", 0);
        System.Diagnostics.Trace.TraceInformation("}", 0);
        System.Diagnostics.Trace.TraceWarning("}", 0);
        ts.TraceInformation("}", 0);

        Console.Write("}", 0);
        Console.Write("}", 0, 1);
        Console.Write("}", 0, 1, 2);
        Console.Write("}", 0, 1, 2, 3);

        System.Diagnostics.Debug.WriteLine("}", ""); // GOOD
        System.Diagnostics.Debug.Write("}", "");     // GOOD

        System.Diagnostics.Debug.Assert(true, "Error", "}", ps);
        sw.Write("}", 0);
        System.Diagnostics.Debug.Print("}", ps);

        Console.WriteLine("}"); // GOOD
    }

    System.IO.StringWriter sw;
}
