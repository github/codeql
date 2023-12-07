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

    void TestStringBuilderFlow()
    {
        var sb = new StringBuilder();
        AppendToStringBuilder(sb, "taint source");
        var sink43 = sb.ToString();
        Check(sink43);

        sb.Clear();
        var nonSink = sb.ToString();
        Check(nonSink);
    }
}
