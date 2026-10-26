using System;
using System.Linq;

class Capture
{
    void M(int i)
    {
        var x = i;

        Action a = () =>
        {
            Use(i);
            i = 1;
            Use(i);
            x = 2;
            Use(x);
            var y = x;

            Action b = () =>
            {
                Use(x);
                Use(y);
            };

            b();
            Use(y);
        };

        var z = 0;
        Action c = () => { z = 1; };

        c();
        Use(i);
        Use(x);
        Use(z);

        z = 0;
        a();
        Use(i);
        Use(x);
        Use(z);

        x = 0;
        M(x);
        Use(x);
        M2(a);
        Use(x);
    }

    void M2(Action a)
    {
        Action b = () => { a = () => { }; };
        b();
        a();
    }

    void LibraryMethodDelegateUpdate(IQueryable<string> strings)
    {
        var i = 0;
        Func<string, int> e = _ => i++;
        strings.Select(e).ToArray();
        Use(i);
    }

    void LibraryMethodDelegateRead(string[] strings)
    {
        var c = 'a';
        var az = strings.Where(s => s.Contains(c)).ToArray();
        string M(string s) { Console.WriteLine(c); return s; };
        strings.Select(M).ToArray();
    }

    void LibraryMethodDelegateExpressionUpdate(IQueryable<string> strings)
    {
        var i = 0;
        System.Linq.Expressions.Expression<Func<string, int>> e = _ => Inc(ref i);
        strings.Select(e).ToArray();
        Use(i);
    }

    static int Inc(ref int i) => i++;

    void LibraryMethodDelegateExpressionRead(IQueryable<string> strings)
    {
        var b = true;
        System.Linq.Expressions.Expression<Func<string, bool>> e = _ => b;
        strings.Where(e).ToArray();
    }

    void DelegateTest()
    {
        int fn(D d) => d();

        var y = 12;

        fn(() =>
        {
            var x = y;
            return x;
        });

        var z = 12; // Should *not* get an SSA definition, but currently does because it is considered live via the lambda
        fn(() =>
        {
            z = 0;
            return z;
        });
    }

    delegate int D();

    void NestedFunctionsTest()
    {
        var a = 12;
        void M1()
        {
            var x = a;
            Use(x);
        };
        M1();

        var b = 12; // Should *not* get an SSA definition, but currently does because it is considered live via the lambda
        void M2()
        {
            b = 0;
            Use(b);
        };
        M2();

        var c = 12; // Should *not* get an SSA definition, but does because the update via the call to `M3` is not considered certain
        void M3()
        {
            c = 0;
            Use(c);
        };
        M3();
        Use(c);

        var d = 12; // Should *not* get an SSA definition, but does because the update via the call to `M4` is not considered certain
        void M4()
        {
            d = 0;
        };
        M4();
        Use(d);

        var e = 12;
        void M5()
        {
            Use(e);
            e = 0; // Should *not* get an SSA definition (`e` is never read), but does since captured variables are conservatively considered live
        }

        var f = 12;
        Use(f);
        void M6()
        {
            f = 0; // Should *not* get an SSA definition (`f` is not read after `M6` is called), but currently does because it is considered live via the call to `M6`
        }
        M6();

        var g = 12; // Should *not* get an SSA definition (`M7` is never called)
        void M7()
        {
            Use(g);
        };

        var h = 12; // Should *not* get an SSA definition, but does since captured variables are conservatively considered live
        void M8()
        {
            h = 0;
            void M9()
            {
                h = 0;
            }
            M9();
            Use(h);
        }

        void M10()
        {
            var i = 0; // Should *not* get an SSA definition, but does because because of simplified implicit-read analysis
            void M11()
            {
                Use(i);
            }
            M10(); // Not an implicit read of `i` as a new copy is created, but not detected by simplified analysis
            i = 1;
            M11();
        }
    }

    void EventsTest()
    {
        void EventFromSource()
        {
            int i = 0;
            MyEventHandler eh = () => Use(i);
            this.Click += eh;
            Click();

            i = 0; // Should *not* get an SSA definition (`Click` is not called after addition)
            MyEventHandler eh2 = () => Use(i);
            this.Click += eh2;
        }

        void EventFromLibrary()
        {
            var i = 0; // Should *not* get an SSA definition, but does because of the imprecise implicit read below
            using (var p = new System.Diagnostics.Process())
            {
                EventHandler exited = (object s, EventArgs e) => Use(i);
                p.Exited += exited; // Imprecise implicit read of `i`; an actual read would happen in a call to e.g. `p.Start()` or `p.OnExited()`
            }
        }
    }

    public delegate void MyEventHandler();

    public event MyEventHandler Click;

    public static void Use<T>(T u) { }
}

class C
{
    void M1()
    {
        int i = 0;

        void M2() => System.Console.WriteLine(i);
        i = 1;
        M2();

        void M3() { i = 2; };
        M3();
        System.Console.WriteLine(i);
    }

    void M2()
    {
        int i = 0;
        void CaptureWrite()
        {
            i = 1;
        }

        void CaptureAndRef(ref int j)
        {
            CaptureWrite();
            j = 2;
        }

        CaptureAndRef(ref i); // explicit definition only (no call definition)
        System.Console.WriteLine(i);
    }
}
