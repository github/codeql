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
}
