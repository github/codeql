using System.Linq;

class Properties
{
    public int[] xs { get; set; }
    public static int[] stat { get; set; }

    public Properties() { Upd(); }

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
        var f = new Properties();
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
            f = new Properties();
        y = f.xs;
        new Properties();
        y = f.xs;
        z = xs;
        w = stat;
    }

    public int LoopProp { get; set; }
    volatile Properties VolatileField = new Properties();
    int SingleAccessedProp { get; set; }

    public void H(int i)
    {
        while (i-- > 0)
        {
            var temp = LoopProp;
        }
        var temp2 = SingleAccessedProp;
    }

    public void I()
    {
        var temp = SingleAccessedProp;
        var f = new Properties();
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

    int NonTrivialProp { get { return 1; } set { } }
    protected virtual int VirtualProp { get; set; }

    public void J()
    {
        this.NonTrivialProp = 1;
        var temp = this.NonTrivialProp;

        this.VirtualProp = 1;
        temp = this.VirtualProp;

        this.VolatileField.xs = new int[1];
        var temp2 = this.VolatileField.xs;
    }

    Properties Props;

    static void SetProps(Properties p) { p.Props = null; }

    void K()
    {
        // This is, in principle, a double definition of `this.Props.Props`: one for the
        // call, and one implicit qualifier update as the call also updates `this.Props`.
        // The SSA library makes the choice to only include the former definition
        SetProps(this);
        var temp = this.Props.Props;
        var temp2 = this.Props.Props.xs;
        temp2 = this.Props.Props.xs;
    }
}
