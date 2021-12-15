// The example used in the QL doc of the SSA library
class Example
{
    int Field;

    void SetField(int i)
    {
        this.Field = i;
        Use(this.Field);
        if (i > 0)
            this.Field = i - 1;
        else if (i < 0)
            SetField(1);
        Use(this.Field);
        Use(this.Field);
    }

    void M(int p, bool b)
    {
        if (b)
        {
            Use(p);
            p = 1;
        }
        Use(p);
    }

    static void Use<T>(T x) { }
}
