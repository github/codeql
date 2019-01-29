using System;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Runtime.Serialization;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI.WebControls;

namespace System.Web
{
    public sealed class HttpRequest
    {
        public string this[string key] { get { return null; } }

        public NameValueCollection QueryString { get { return null; } }

        public NameValueCollection Headers { get { return null; } }

        public string RawUrl { get { return null; } }

        public Uri Url { get { return null; } }
    }
}

namespace System.Web.UI.WebControls
{
    public class TextBox
    {
        public string Text { get; set; }
    }
}

namespace System.Runtime.Serialization
{
    public sealed class DataContractAttribute : Attribute { }
    public sealed class DataMemberAttribute : Attribute { }
}

/// <summary>
/// All (tainted) sinks are named `sinkN`, for some N, and all non-sinks are named
/// `nonSinkN`, for some N. Both sinks and non-sinks are passed to the method `Check`
/// for convenience in the test query.
/// </summary>
public class LocalDataFlow
{
    public async void M(bool b)
    {
        // Assignment, tainted
        var sink0 = "taint source";
        Check(sink0);

        // Assignment, not tainted
        var nonSink0 = "";
        Check(nonSink0);

        // Assignment (concatenation), tainted
        var sink1 = "abc";
        sink1 += sink0;
        Check(sink1);

        // Assignment (concatenation), not tainted
        nonSink0 += "abc";
        Check(nonSink0);

        // Assignment (indexer), tainted
        var sink2 = new Dictionary<int, string[]>();
        sink2[0][1] = sink1;
        Check(sink2);

        // Assignment (indexer), not tainted
        var nonSink1 = new Dictionary<string, string>();
        nonSink1[""] = nonSink0;
        nonSink1[sink1] = ""; // do not track tainted keys
        Check(nonSink1);

        // Concatenation, tainted
        var sink5 = sink1 + "ok";
        Check(sink5);

        // Concatenation, not tainted
        nonSink0 = nonSink0 + "test";
        Check(nonSink0);

        // Parenthesized expression, tainted
        var sink6 = (sink5);
        Check(sink6);

        // Parenthesized expression, not tainted
        nonSink0 = (nonSink0);
        Check(nonSink0);

        // Conditional expression, tainted
        var sink7 = b ? "a" : sink6;
        Check(sink7);

        // Conditional expression, not tainted
        nonSink0 = b ? "abc" : "def";
        Check(nonSink0);

        // Cast, tainted
        var sink8 = (object)sink7;
        Check(sink8);

        // Cast, not tainted
        var nonSink3 = (object)nonSink0;
        Check(nonSink3);

        // Cast, tainted
        var sink9 = sink8 as string;
        Check(sink9);

        // Cast, not tainted
        nonSink3 = nonSink0 as object;
        Check(nonSink3);

        // Array creation (initializer), tainted
        var sink10 = new object[] { sink9 };
        Check(sink10);

        // Array creation (initializer), not tainted
        var nonSink4 = new object[] { 42 };
        Check(nonSink4);

        // Object creation (collection initializer), tainted
        var sink11 = new Dictionary<string, string> { { "", sink9 } };
        Check(sink11);

        // Object creation (collection initializer), not tainted
        nonSink1 = new Dictionary<string, string> { { sink9, "" } };
        Check(nonSink1);

        // Data-preserving LINQ, tainted
        var sink14 = sink11.First(x => x.Value != null);
        Check(sink14);

        // Data-preserving LINQ, not tainted
        nonSink3 = nonSink1.First(x => x.Value != null);
        Check(nonSink1);

        // Standard method with a tainted argument, tainted
        var sink15 = Int32.Parse(sink9);
        Check(sink15);
        int nonSink2;
        var sink16 = Int32.TryParse(sink9, out nonSink2);
        Check(sink16);
        var sink17 = nonSink0.Replace(" ", sink9);
        Check(sink17);
        var sink18 = String.Format(nonSink0, sink9);
        Check(sink18);
        var sink19 = String.Format(sink18, nonSink0);
        Check(sink19);
        var sink45 = bool.Parse(sink9);
        Check(sink45);
        bool nonSink13;
        var sink46 = bool.TryParse(sink9, out nonSink13);
        Check(sink46);
        var sink47 = Convert.ToByte(sink46);
        Check(sink47);
        var sink49 = String.Concat("", sink47);
        Check(sink49);
        var sink50 = String.Copy(sink49);
        Check(sink50);
        var sink51 = String.Join(", ", "", sink50, "");
        Check(sink51);
        var sink52 = "".Insert(0, sink51);
        Check(sink52);

        // Standard method with a non-tainted argument, not tainted
        nonSink2 = Int32.Parse(nonSink0);
        Check(nonSink2);
        var nonSink7 = Int32.TryParse(nonSink0, out nonSink2);
        Check(nonSink7);
        nonSink0 = nonSink0.Replace(" ", nonSink0);
        Check(nonSink0);
        nonSink0 = String.Format(nonSink0, nonSink0);
        Check(nonSink0);
        nonSink7 = bool.Parse(nonSink0);
        Check(nonSink7);
        nonSink7 = bool.TryParse(nonSink0, out nonSink13);
        Check(nonSink7);
        var nonSink14 = Convert.ToByte(nonSink7);
        Check(nonSink14);
        nonSink0 = String.Concat("", nonSink7);
        Check(nonSink0);
        nonSink0 = String.Copy(nonSink0);
        Check(nonSink0);
        nonSink0 = String.Join(", ", "", nonSink0, "");
        Check(nonSink0);
        nonSink0 = "".Insert(0, nonSink0);
        Check(nonSink0);

        // Comparison with constant, tainted
        var sink20 = sink15 > 42;
        Check(sink20);
        var sink21 = sink9.Equals("abc");
        Check(sink21);
        var sink22 = sink8.Equals((object)41);
        Check(sink22);

        // Comparison with non-constant, not tainted
        nonSink7 = sink0.Equals(sink1);
        Check(nonSink7);
        nonSink7 = sink8.Equals(nonSink3);
        Check(nonSink7);

        // Indexer access, tainted
        var sink23 = sink11[""];
        Check(sink23);

        // Indexer access, not tainted
        nonSink0 = nonSink1[""];
        Check(nonSink0);

        // Array access, tainted
        var sink24 = sink10[0];
        Check(sink24);

        // Array access, not tainted
        nonSink3 = nonSink4[0];
        Check(nonSink3);

        // Logical operation using tainted operand, tainted
        var sink25 = sink20 || false;
        Check(sink25);

        // Logical operation using non-tainted operands, not tainted
        nonSink7 = nonSink7 || false;
        Check(nonSink7);

        // Ad hoc tracking (System.Uri), tainted
        var sink26 = new System.Uri(sink23);
        Check(sink26);
        var sink27 = sink26.ToString();
        Check(sink27);
        var sink28 = sink26.PathAndQuery;
        Check(sink28);
        var sink29 = sink26.Query;
        Check(sink29);
        var sink30 = sink26.OriginalString;
        Check(sink30);

        // Ad hoc tracking (System.Uri), not tainted
        var nonSink8 = new System.Uri(nonSink0);
        Check(nonSink8);
        nonSink0 = nonSink8.ToString();
        Check(nonSink0);
        nonSink0 = nonSink8.PathAndQuery;
        Check(nonSink0);
        nonSink0 = nonSink8.Query;
        Check(nonSink0);
        nonSink0 = nonSink8.OriginalString;
        Check(nonSink0);

        // Ad hoc tracking (System.IO.StringReader), tainted
        var sink31 = new System.IO.StringReader(sink30);
        Check(sink31);
        var sink32 = sink31.ReadToEnd();
        Check(sink32);

        // Ad hoc tracking (System.IO.StringReader), not tainted
        var nonSink9 = new System.IO.StringReader(nonSink0);
        Check(nonSink9);
        nonSink0 = nonSink9.ReadToEnd();
        Check(nonSink0);

        // Ad hoc tracking (System.String), tainted
        var sink33 = (string)sink32.Substring(0).ToLowerInvariant().ToUpper().Trim(' ').Replace("a", "b").Insert(0, "").Clone();
        Check(sink33);
        var sink48 = sink33.Normalize().Remove(4, 5).Split(' ');
        Check(sink48);

        // Ad hoc tracking (System.String), not tainted
        nonSink0 = (string)nonSink0.Substring(0).ToLowerInvariant().ToUpper().Trim(' ').Replace("a", "b").Insert(0, "").Clone();
        Check(nonSink0);
        var nonSink15 = nonSink0.Normalize().Remove(4, 5).Split(' ');
        Check(nonSink15);

        // Ad hoc tracking (System.Text.StringBuilder), tainted
        var sink34 = new StringBuilder(sink33);
        Check(sink34);
        var sink35 = sink34.ToString();
        Check(sink35);
        var sink36 = new StringBuilder("");
        sink36.AppendLine(sink35);
        Check(sink36);

        // Ad hoc tracking (System.Text.StringBuilder), not tainted
        var nonSink10 = new StringBuilder(nonSink0);
        Check(nonSink10);
        nonSink0 = nonSink10.ToString();
        Check(nonSink0);
        nonSink10.AppendLine(nonSink0);
        Check(nonSink10);

        // Ad hoc tracking (System.Lazy), tainted
        var sink40 = new Lazy<string>(TaintedMethod);
        Check(sink40);
        var sink41 = sink40.Value;
        Check(sink41);
        var sink42 = new Lazy<string>(() => "taint source");
        Check(sink42);
        var sink43 = sink42.Value;
        Check(sink43);

        // Ad hoc tracking (System.Lazy), not tainted
        var nonSink12 = new Lazy<string>(NonTaintedMethod);
        Check(nonSink12);
        nonSink0 = nonSink12.Value;
        Check(nonSink0);
        nonSink12 = new Lazy<string>(() => "");
        Check(nonSink12);
        nonSink0 = nonSink12.Value;
        Check(nonSink0);

        // Ad hoc tracking (collections), tainted
        var sink3 = new Dictionary<int, string>();
        sink3.Add(0, sink1);
        Check(sink3);
        var sink12 = sink3.Values;
        Check(sink12);
        var sink13 = sink12.Reverse();
        Check(sink13);

        // Ad hoc tracking (collections), not tainted
        nonSink1.Add("", nonSink0);
        nonSink1.Add(sink1, ""); // do not track tainted keys
        Check(nonSink1);
        var nonSink5 = nonSink1.Values;
        Check(nonSink5);
        var nonSink6 = nonSink5.Reverse();
        Check(nonSink6);

        // Ad hoc tracking (data contracts), tainted
        var taintedDataContract = new DataContract();
        var sink53 = taintedDataContract.AString;
        Check(sink53);
        var sink54 = taintedDataContract.AList[0].AString;
        Check(sink54);

        // Ad hoc tracking (data contracts), not tainted
        var nonTaintedDataContract = new DataContract();
        nonSink0 = nonTaintedDataContract.AString;
        Check(nonSink0);
        nonSink2 = taintedDataContract.AnInt;
        Check(nonSink2);
        nonSink2 = taintedDataContract.AList[0].AnInt;
        Check(nonSink2);

        // Ad hoc tracking (TextBox), tainted
        TextBox taintedTextBox = null;
        var sink60 = taintedTextBox.Text;
        Check(sink60);

        // Ad hoc tracking (HttpRequest), not tainted
        TextBox nonTaintedTextBox = null;
        nonSink0 = nonTaintedTextBox.Text;
        Check(nonSink0);

        // Iteration over a tracked expression, tainted
        foreach (var sink61 in sink10)
            Check(sink61);
        IEnumerator sink62 = sink10.GetEnumerator();
        Check(sink62);
        var sink63 = sink62.Current;
        Check(sink63);
        IEnumerator<KeyValuePair<int, string>> sink64 = sink3.GetEnumerator();
        Check(sink64);
        var sink65 = sink64.Current;
        Check(sink65);
        var sink66 = sink65.Value;
        Check(sink66);

        // Iteration over a tracked expression, not tainted
        foreach (var nonSink17 in nonSink4)
            Check(nonSink17);
        IEnumerator nonSink18 = nonSink4.GetEnumerator();
        Check(nonSink18);
        nonSink3 = nonSink18.Current;
        Check(nonSink3);
        IEnumerator<KeyValuePair<string, string>> nonSink19 = nonSink1.GetEnumerator();
        Check(nonSink19);
        var nonSink20 = nonSink19.Current;
        Check(nonSink20);
        nonSink0 = nonSink20.Value;
        Check(nonSink0);

        // async await, tainted
        var sink67 = Task.Run(() => "taint source");
        Check(sink67);
        var sink68 = await sink67;
        Check(sink68);

        // async await, not tainted
        var nonSink21 = Task.Run(() => "");
        Check(nonSink21);
        nonSink0 = await nonSink21;
        Check(nonSink0);

        // Interpolated string, tainted
        var sink69 = $"test {sink1}";
        Check(sink69);

        // Interpolated string, not tainted
        nonSink0 = $"test {nonSink0}";
        Check(nonSink0);

        // Assignment expression, exact
        var sink70 = sink0 = sink0;
        Check(sink70);

        // Assignment expression, not tainted
        nonSink0 = nonSink0 = nonSink0;
        Check(nonSink0);

        // `is` pattern, tainted
        if (sink70 is string sink71)
            Check(sink71);

        // `is` pattern, not tainted
        if (nonSink0 is string nonSink16)
            Check(nonSink16);

        // `switch` pattern, tainted
        switch (sink70)
        {
            case string sink72:
                Check(sink72);
                break;
        }

        // `switch` pattern, not tainted
        switch (nonSink0)
        {
            case string nonSink17:
                Check(nonSink17);
                break;
        }
    }

    static void Check<T>(T x) { }

    static void Use<T>(T x) { }

    string TaintedMethod() { return ""; }

    string NonTaintedMethod() { return ""; }

    [DataContract]
    public class DataContract
    {
        [DataMember]
        public string AString { get; set; }

        int anInt;
        public int AnInt { get { return anInt; } set { anInt = value; } }

        [DataMember]
        public List<DataContract> AList { get; set; }
    }

    public void TaintedParameter(string tainted)
    {
        Check(tainted);
    }

    public void NonTaintedParameter(string nonTainted)
    {
        Check(nonTainted);
    }
}
