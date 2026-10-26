using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

/// <summary>
/// All (tainted) sinks are named `sink[Param|Field|Property]N`, for some N, and all
/// non-sinks are named `nonSink[Param|Field|Property]N`, for some N.
/// Both sinks and non-sinks are passed to the method `Check` for convenience in the
/// test query.
/// </summary>
public class DataFlowStringBuilder
{
    static void Check<T>(T x) { }

    static void AppendToStringBuilder(StringBuilder sb, string s)
    {
        sb.Append(s);
    }

    static void AppendToStringBuilderInterpolated(StringBuilder sb, string s)
    {
        sb.Append($"a{s}b");
    }

    void TestStringBuilderFlow()
    {
        var sb = new StringBuilder();
        AppendToStringBuilder(sb, "taint source");
        var sink0 = sb.ToString();
        Check(sink0);

        var sb1 = new StringBuilder();
        sb1.Append(sb);
        var sink1 = sb1.ToString();
        Check(sink1);

        var sb2 = new StringBuilder();
        sb2.Append($"{sb}");
        var sink2 = sb2.ToString();
        Check(sink2);

        sb.Clear();
        var nonSink = sb.ToString();
        Check(nonSink);

        AppendToStringBuilderInterpolated(sb, "taint source");
        var sink3 = sb.ToString();
        Check(sink3);
    }
}
