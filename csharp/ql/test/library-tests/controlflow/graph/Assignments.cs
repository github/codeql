class Assignments
{
    void M()
    {
        int x = 0;
        x += 1;

        dynamic d = 0;
        d -= 2;

        var a = new Assignments();
        a += this;

        Event += (sender, e) => { };
    }

    public static Assignments operator +(Assignments x, Assignments y)
    {
        return x;
    }

    delegate void EventHandler(object sender, object e);
    event EventHandler Event;
    int IntField;
    string StringField;

    void SetParamSingle(out int x)
    {
        x = 42;
    }

    void SetParamMulti(out int x, object o, out string y)
    {
        x = 42;
        y = "Hello";
    }

    void M2()
    {
        int x1;
        SetParamSingle(out x1);
        SetParamSingle(out IntField);
        SetParamMulti(out var y, null, out StringField);
        SetParamMulti(out IntField, null, out StringField);
    }
}
