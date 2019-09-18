using System;

class Assignables
{
    int Field = 0;
    int Property { get; set; } = 1;
    delegate void EventHandler(object sender, object e);
    event EventHandler Event;
    int this[int i] { get { return i; } set { } }

    void M(int parameter)
    {
        var variable = 0;
        variable = parameter;
        variable--;
        parameter = Field;
        parameter++;
        Field = Property;
        Field--;
        Property = this[variable];
        Property++;
        EventHandler callback = (sender, e) => { };
        Event += callback;
        Event(this, null);
        Event -= callback;
        this[Property] = variable;
        this[Field]++;
        Out(out variable);
        Out(out Field);
        RefCertain(variable, ref Field, true);
        RefUncertain(variable, ref Field);
        RefUncertain2(variable, ref Field);
        NonRef(variable, ref Field);
        RefCertainOneOf(ref Field, ref Field); // incorrectly marked as uncertain
    }

    void Out(out int o)
    {
        o = 0;
    }

    void RefCertain<T>(T x, ref T y, bool b)
    {
        if (b)
            y = x;
        else
            RefCertain(x, ref y, true);
    }

    void RefUncertain(int x, ref int y)
    {
        if (x > y)
            y = x;
    }

    void RefUncertain2(int x, ref int y)
    {
        if (x > y)
            y = x;
        else
            RefUncertain(x, ref y);
    }

    void RefCertainOneOf(ref int x, ref int y)
    {
        if (x > y)
            x = 1;
        else
            y = 1;
    }

    void NonRef(int x, ref int y)
    {
    }

    void LocalNoInit(System.Collections.Generic.IEnumerable<string> ss)
    {
        foreach (var s in ss)
        {
            try
            {
                var temp = s + "";
            }
            catch (Exception e)
            {
            }
        }
    }

    void Tuples()
    {
        (int x, (bool b, string s)) = (0, (false, ""));
        (x, (b, s)) = (1, (true, "a"));
        (x, (b, s)) = GetTuple();
        (int f1, (bool f1, string f3)) tuple = GetTuple();
        (Property, this[0]) = (2, 3);
        (x, (b, x)) = (4, (false, 5));
        (b, (x, x)) = (true, (6, 7));
    }

    (int, (bool, string)) GetTuple()
    {
        return (0, (false, ""));
    }

    unsafe void AddressOf()
    {
        var i = 0;
        int* p = &i;
        *p = 1;
    }

    Assignables(out int i, ref string s) { i = 1; s = ""; }

    void OutRefConstructor()
    {
        int i;
        string s = "";
        new Assignables(out i, ref s);
    }

    void Nameof()
    {
        int i;
        var s = nameof(i); // not a read of `i`
        s = nameof(this.Field); // not a read of `this.Field`
    }

    delegate void Delegate(ref int i, out string s);
    void DelegateRef(Delegate d)
    {
        var x = 0;
        d(ref x, out string s);
    }

    void UsingDeclarations()
    {
        using var x = new System.IO.MemoryStream();
    }
}

// semmle-extractor-options: /langversion:8.0
