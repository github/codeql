using System;
using System.Collections.Generic;
using System.Linq;

class Capture
{
    void In(string tainted)
    {
        void CaptureIn1()
        {
            var sink27 = tainted;
            Check(sink27);
        };
        CaptureIn1();

        void CaptureIn2()
        {
            void M()
            {
                var sink28 = tainted;
                Check(sink28);
            };
            M();
        };
        CaptureIn2();

        Func<string, string> captureIn3 = arg =>
        {
            var sink29 = tainted;
            Check(sink29);
            return arg;
        };
        new[] { " " }.Select(captureIn3).ToArray();

        void CaptureIn1NotCalled()
        {
            var nonSink0 = tainted;
            Check(nonSink0);
        };

        void CaptureIn2NotCalled()
        {
            void M()
            {
                var nonSink0 = tainted;
                Check(nonSink0);
            };
        };
        CaptureIn2NotCalled();
        void CaptureTest(string nonSink0, string sink39)
        {
            RunAction(() =>       // Check each lambda captures the correct arguments
            {
                Check(nonSink0);
                RunAction(() =>
                {
                    Check(sink39);
                });
            });
        }
        CaptureTest("not tainted", tainted);
    }

    void Out()
    {
        string sink30 = "";
        void CaptureOut1()
        {
            sink30 = "taint source";
        };
        CaptureOut1();
        Check(sink30);

        string sink31 = "";
        void CaptureOut2()
        {
            void M()
            {
                sink31 = "taint source";
            };
            M();
        };
        CaptureOut2();
        Check(sink31);

        string sink32 = "";
        Func<string, string> captureOut3 = arg =>
        {
            sink32 = "taint source";
            return arg;
        };
        new[] { " " }.Select(captureOut3).ToArray();
        Check(sink32);

        string nonSink0 = "";
        void CaptureOut1NotCalled()
        {
            nonSink0 = "taint source";
        };
        Check(nonSink0);

        void CaptureOut2NotCalled()
        {
            void M()
            {
                nonSink0 = "taint source";
            };
        };
        CaptureOut2NotCalled();
        Check(nonSink0);
        string sink40 = "";
        void CaptureOutMultipleLambdas()
        {
            RunAction(() => {
                sink40 = "taint source";
            });
            RunAction(() => {
                nonSink0 = "not tainted";
            });
        };
        CaptureOutMultipleLambdas();
        Check(sink40); Check(nonSink0);
    }

    void Through(string tainted)
    {
        string sink33 = "";
        void CaptureThrough1()
        {
            sink33 = tainted;
        };
        CaptureThrough1();
        Check(sink33);

        string sink34 = "";
        void CaptureThrough2()
        {
            void M()
            {
                sink34 = tainted;
            };
            M();
        };
        CaptureThrough2();
        Check(sink34);

        string sink35 = "";
        Func<string, string> captureThrough3 = arg =>
        {
            sink35 = tainted;
            return arg;
        };
        new[] { " " }.Select(captureThrough3).ToArray();
        Check(sink35);

        string CaptureThrough4()
        {
            return tainted;
        };
        var sink36 = CaptureThrough4();
        Check(sink36);

        var sink37 = "";
        void CaptureThrough5(string p)
        {
            sink37 = p;
        };
        CaptureThrough5(tainted);
        Check(sink37);

        string nonSink0 = "";
        void CaptureThrough1NotCalled()
        {
            nonSink0 = tainted;
        };
        Check(nonSink0);

        void CaptureThrough2NotCalled()
        {
            void M()
            {
                nonSink0 = tainted;
            };
        };
        CaptureThrough2NotCalled();
        Check(nonSink0);

        string Id(string s)
        {
            string M() => s;
            return M();
        }

        var sink38 = Id(tainted);
        Check(sink38);
        nonSink0 = Id("");
        Check(nonSink0);
    }

    static void Check<T>(T x) { }

    static void RunAction(Action a)
    {
        a.Invoke();
    }
}
