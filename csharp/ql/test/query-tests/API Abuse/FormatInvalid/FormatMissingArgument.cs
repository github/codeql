using System;
using System.Text;

class Class1
{
    void TestFormatMissingArgument()
    {
        // GOOD: All args supplied
        String.Format("{0}", 0);

        // BAD: Missing {1}
        String.Format("{1}", 0); // $ Alert Sink

        // BAD: Missing {2} and {3}
        String.Format("{2} {3}", 0, 1); // $ Alert Sink

        // GOOD: An array has been supplied.
        String.Format("{0} {1} {2}", args);

        // GOOD: A collection has been supplied.
        String.Format("{0} {1} {2}", [0, 1, 2]);

        // GOOD: All arguments supplied to params
        String.Format("{0} {1} {2} {3}", 0, 1, 2, 3);

        helper("{1}"); // $ Source=source1
    }

    void helper(string format)
    {
        // BAD: Missing {1}
        String.Format(format, 0); // $ Alert=source1 Sink=source1
    }

    void TestCompositeFormatMissingArgument()
    {
        var format0 = CompositeFormat.Parse("{0}");
        var format1 = CompositeFormat.Parse("{1}"); // $ Source=source2
        var format01 = CompositeFormat.Parse("{0}{1}");
        var format23 = CompositeFormat.Parse("{2}{3}"); // $ Source=source3

        // GOOD: All args supplied
        String.Format<string>(null, format0, "");

        // BAD: Missing {1}
        String.Format<string>(null, format1, ""); // $ Alert=source2 Sink=source2

        // GOOD: All args supplied
        String.Format<string, string>(null, format01, "", "");

        // BAD: Missing {2} and {3}
        String.Format<string, string>(null, format23, "", ""); // $ Alert=source3 Sink=source3


        // GOOD: All arguments supplied
        sb.AppendFormat(null, format0, "");
        sb.AppendFormat<string>(null, format0, "");

        // BAD: Missing {1}
        sb.AppendFormat(null, format1, ""); // $ Alert=source2 Sink=source2
        sb.AppendFormat<string>(null, format1, ""); // $ Alert=source2 Sink=source2

        // GOOD: All args supplied
        sb.AppendFormat<string, string>(null, format01, "", "");

        // BAD: Missing {2} and {3}
        sb.AppendFormat<string, string>(null, format23, "", ""); // $ Alert=source3 Sink=source3


        var span = new Span<char>();

        // GOOD: All args supplied
        span.TryWrite(null, format0, out _, "");
        span.TryWrite<string>(null, format0, out _, "");

        // BAD: Missing {1}
        span.TryWrite(null, format1, out _, ""); // $ Alert=source2 Sink=source2
        span.TryWrite<string>(null, format1, out _, ""); // $ Alert=source2 Sink=source2

        // GOOD: All args supplied
        span.TryWrite<string, string>(null, format01, out _, "", "");

        // BAD: Missing {2} and {3}
        span.TryWrite<string, string>(null, format23, out _, "", ""); // $ Alert=source3 Sink=source3
    }

    object[] args;

    StringBuilder sb;
}
