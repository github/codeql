using System;

public class Ssa
{
    public void M(string tainted, string nonTainted)
    {
        // Source to definition, tainted
        var ssaSink0 = tainted;
        Check(ssaSink0);

        // Source to definition, not tainted
        var nonSink0 = nonTainted;
        Check(nonSink0);

        // Read to read, tainted
        Use(ssaSink0);

        // Read to read, not tainted
        Use(nonSink0);

        // Definition to phi node, tainted
        string ssaSink1 = "";
        if (nonTainted.Length > 0)
            ssaSink1 = ssaSink0;
        Check(ssaSink1);

        // Definition to phi node, not tainted
        string nonSink1 = "";
        if (nonTainted.Length > 0)
            nonSink1 = nonSink0;
        Check(nonSink1);

        // Last read to phi node, tainted
        string ssaSink2 = "";
        if (nonTainted.Length > 0)
        {
            ssaSink2 = ssaSink0;
            if (nonTainted.Length > 1)
                Use(ssaSink2);
            else
                Use(ssaSink2);
        }
        Check(ssaSink2);

        // Last read to phi node, not tainted
        string nonSink2 = "";
        if (nonTainted.Length > 0)
        {
            nonSink2 = nonSink0;
            if (nonTainted.Length > 1)
                Use(nonSink2);
            else
                Use(nonSink2);
        }
        Check(nonSink2);

        // Definition to uncertain definition, tainted
        string ssaSink3 = tainted;
        Uncertain(ref ssaSink3);
        Check(ssaSink3);

        // Definition to uncertain definition, not tainted
        Uncertain(ref nonSink0);
        Check(nonSink0);

        // Definition to uncertain definition (field qualifier), tainted
        this.S.SsaFieldSink0 = tainted;
        Uncertain(ref this.S);
        Check(this.S.SsaFieldSink0);

        // Definition to uncertain definition (field qualifier), not tainted
        this.S.SsaFieldNonSink0 = "";
        Uncertain(ref this.S);
        Check(this.S.SsaFieldNonSink0);

        // Certain definition
        nonSink0 = tainted;
        Certain(ref nonSink0);
        Check(nonSink0);
        this.S.SsaFieldNonSink0 = tainted;
        Certain(ref this.S);
        Check(this.S.SsaFieldNonSink0);
        this.S.SsaFieldNonSink0 = tainted;
        SetS();
        Check(this.S.SsaFieldNonSink0);

        // Last read to uncertain definition, tainted
        string ssaSink4 = "";
        if (nonTainted.Length > 0)
        {
            ssaSink4 = ssaSink0;
            if (nonTainted.Length > 1)
                Use(ssaSink4);
            else
                Use(ssaSink4);
        }
        Uncertain(ref ssaSink4);
        Check(ssaSink4);

        // Last read to uncertain definition, not tainted
        string nonSink3 = "";
        if (nonTainted.Length > 0)
        {
            nonSink3 = nonSink0;
            if (nonTainted.Length > 1)
                Use(nonSink3);
            else
                Use(nonSink3);
        }
        Uncertain(ref nonSink3);
        Check(nonSink3);

        // Last read to uncertain definition (field qualifier), tainted
        this.S.SsaFieldSink1 = "";
        if (nonTainted.Length > 0)
        {
            this.S.SsaFieldSink1 = ssaSink0;
            if (nonTainted.Length > 1)
                Use(this.S.SsaFieldSink1);
            else
                Use(this.S.SsaFieldSink1);
        }
        Uncertain(ref this.S);
        Check(this.S.SsaFieldSink1);

        // Last read to uncertain definition (field qualifier), not tainted
        this.S.SsaFieldNonSink0 = "";
        if (nonTainted.Length > 0)
        {
            this.S.SsaFieldNonSink0 = nonSink0;
            if (nonTainted.Length > 1)
                Use(this.S.SsaFieldNonSink0);
            else
                Use(this.S.SsaFieldNonSink0);
        }
        Uncertain(ref this.S);
        Check(this.S.SsaFieldNonSink0);
    }

    static void Check<T>(T x) { }

    static void Use<T>(T x) { }

    static void Certain<T>(ref T t)
    {
        if (t == null)
            t = default(T);
        else
            t = t;
    }

    static void Uncertain<T>(ref T t)
    {
        if (t == null)
            Certain(ref t);
    }

    string SsaFieldSink0;

    string SsaFieldSink1;

    string SsaFieldNonSink0;

    Ssa S;

    void SetS() { this.S = null; }

    void Loop(string tainted, int i)
    {
        string ssaSink5 = "";
        if (i-- > 0)
        {
            ssaSink5 = tainted;
            while (i-- > 0)
            {
                Use(ssaSink5);
                Use(ssaSink5);
            }
        }
        Check(ssaSink5);
    }
}

// semmle-extractor-options: /r:System.Collections.dll /r:System.Collections.Specialized.dll /r:System.Linq.dll /r:System.Private.Uri.dll /r:System.Runtime.Extensions.dll
