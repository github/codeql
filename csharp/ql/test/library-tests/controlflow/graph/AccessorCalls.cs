class AccessorCalls
{
    int Field;
    int Prop { get; set; }
    int this[int i] { get => i; set { } }
    public delegate void EventHandler();
    event EventHandler Event { add { } remove { } }
    AccessorCalls x;

    void M1(EventHandler e)
    {
        this.Field = this.Field;
        this.Prop = this.Prop;
        this[0] = this[1];
        this.Event += e;
        this.Event -= e;
    }

    void M2(EventHandler e)
    {
        this.x.Field = this.x.Field;
        this.x.Prop = this.x.Prop;
        this.x[0] = this.x[1];
        this.x.Event += e;
        this.x.Event -= e;
    }

    void M3()
    {
        this.Field++;
        this.Prop++;
        this[0]++;
    }

    void M4()
    {
        this.x.Field++;
        this.x.Prop++;
        this.x[0]++;
    }

    void M5()
    {
        this.Field += this.Field;
        this.Prop += this.Prop;
        this[0] += this[0];
    }

    void M6()
    {
        this.x.Field += this.x.Field;
        this.x.Prop += this.x.Prop;
        this.x[0] += this.x[0];
    }

    void M7(int i)
    {
        (this.Field, this.Prop, (i, this[0])) = (this.Field, this.Prop, (0, this[1]));
    }

    void M8(int i)
    {
        (this.x.Field, this.x.Prop, (i, this.x[0])) = (this.x.Field, this.x.Prop, (0, this.x[1]));
    }

    void M9(object o, int i, EventHandler e)
    {
        dynamic d = o;
        d.MaybeProp1 = d.MaybeProp2;
        d.MaybeProp++;
        d.MaybeEvent += e;
        d[0] += d[1];
        (d.MaybeProp1, this.Prop, (i, d[0])) = (d.MaybeProp1, this.Prop, (0, d[1]));
    }
}
