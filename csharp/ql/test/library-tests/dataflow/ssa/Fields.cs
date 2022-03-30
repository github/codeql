using System.Linq;

class Fields
{
    public int[] xs;
    public static int[] stat;

    public Fields() { Upd(); }

    public void Upd()
    {
        xs = new int[1];
        stat = new int[0];
    }

    public void F()
    {
        int[] x = xs;
        Upd();
        x = xs;
        if (x[0] > 2)
            Upd();
        x = this.xs;
        xs = new int[2];
        x = xs;
    }

    public void G()
    {
        var f = new Fields();
        int[] y = f.xs;
        int[] z = xs;
        int[] w = stat;
        this.F();
        y = f.xs;
        z = xs;
        w = stat;
        f.F();
        y = f.xs;
        z = xs;
        w = stat;
        xs = new int[3];
        y = f.xs;
        z = xs;
        f.xs = new int[4];
        y = f.xs;
        z = xs;
        if (z[0] > 2)
            f = new Fields();
        y = f.xs;
        new Fields();
        y = f.xs;
        z = xs;
        w = stat;
    }

    int LoopField = 0;
    volatile int VolatileField = 0;
    int SingleAccessedField = 0;

    public void H()
    {
        while (VolatileField > 0)
        {
            var temp = LoopField;
        }

        VolatileField = 1;
        var temp2 = VolatileField;

        temp2 = SingleAccessedField;
    }

    public void I()
    {
        var temp = SingleAccessedField;
        var f = new Fields() { Field = null };
        System.Action a = () => { f.xs = new int[1]; };
        System.Action b = () => { };
        f.xs = new int[1];
        a(); // implicit update of `f.xs`
        this.xs = f.xs;
        f.xs = new int[1];
        b(); // not an implicit update of `f.xs`
        this.xs = f.xs;
        this.xs.Select(_ => { a(); return 0; }).ToArray(); // implicit update of `f.xs`
        this.xs = f.xs;
        f.xs = new int[1];
        this.xs.Select(_ => { b(); return 0; }).ToArray(); // not an implicit update of `f.xs`
        this.xs = f.xs;
    }

    public Fields Field;

    void J(Fields f)
    {
        f.Field = new Fields();
        var temp = f.Field.Field;
        temp = f.Field.Field.Field;
        temp = f.Field.Field.Field.Field;
        temp = f.Field.Field.Field.Field;
        this.Field = f.Field;
        I();
        temp = this.Field;
    }

    static void SetField(Fields f) { f.Field = null; }

    void K()
    {
        // This is, in principle, a double definition of `this.Field.Field`: one for the
        // call, and one implicit qualifier update as the call also updates `this.Field`.
        // The SSA library makes the choice to only include the former definition
        SetField(this);
        var temp = this.Field.Field;
        var temp2 = this.Field.Field.xs;
        temp2 = this.Field.Field.xs;
    }
}
