using System;
using System.Text;

class C
{
    void FormatTests()
    {
        // GOOD: Uses all args
        String.Format("{0} {1} {2}", 0, 1, 2);

        // BAD: Missing arg {0}
        String.Format("X", 1); // $ Alert Sink

        // BAD: Missing {1}
        String.Format("{0}", 1, 2); // $ Alert Sink

        // BAD: Missing {1}
        String.Format("{0} {0}", 1, 2); // $ Alert Sink

        // BAD: Missing {0}
        String.Format("{1} {1}", 1, 2); // $ Alert Sink

        // BAD: Missing {0}, {1} and {2}
        String.Format("abcdefg", 0, 1, 2); // $ Alert Sink

        // BAD: {0} is unused
        String.Format("{{sdc}}", 0); // $ Alert Sink

        // GOOD: {0} is used
        String.Format("{{{0:D}}}", 0);

        // GOOD: Uses all args in params
        String.Format("{0} {1} {2} {3}", 0, 1, 2, 3);

        // GOOD: Params supplied
        String.Format("{0} {1} {2}", ps);

        // BAD: Would display "{0}"
        String.Format("{{0}}", 1); // $ Alert Sink

        // GOOD: Ignore the empty string as it's often used as the default value
        // of GetResource().
        String.Format("", 1);
    }

    void CompositeFormatTests()
    {
        var format = CompositeFormat.Parse("X"); // $ Source
        var format00 = CompositeFormat.Parse("{0}{0}"); // $ Source
        var format11 = CompositeFormat.Parse("{1}{1}"); // $ Source

        // BAD: Unused arg {0}
        String.Format<string>(null, format, ""); // $ Alert Sink

        // BAD: Unused arg {1}
        String.Format<string, string>(null, format00, "", ""); // $ Alert Sink

        // BAD: Unused arg {0}
        String.Format<string, string>(null, format11, "", ""); // $ Alert Sink

        // BAD: Unused arg {0}
        sb.AppendFormat(null, format, ""); // $ Alert Sink
        sb.AppendFormat<string>(null, format, ""); // $ Alert Sink

        // BAD: Unused arg {1}
        sb.AppendFormat<string, string>(null, format00, "", ""); // $ Alert Sink

        // BAD: Unused arg {0}
        sb.AppendFormat<string, string>(null, format11, "", ""); // $ Alert Sink

        var span = new Span<char>();

        // BAD: Unused arg {0}
        span.TryWrite(null, format, out _, ""); // $ Alert Sink
        span.TryWrite<string>(null, format, out _, ""); // $ Alert Sink

        // BAD: Unused arg {1}
        span.TryWrite<string, string>(null, format00, out _, "", ""); // $ Alert Sink

        // BAD: Unused arg {0}
        span.TryWrite<string, string>(null, format11, out _, "", ""); // $ Alert Sink

    }

    object[] ps;

    StringBuilder sb;
}
