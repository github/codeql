using System;

class Good
{
    private int id;

    public Good(int Id)
    {
        this.id = Id;
    }

    public bool Equals(Good g) =>
      this.id == g.id;

    public override bool Equals(object o)
    {
        if (o is Good g && g.GetType() == typeof(Good))
            return this.Equals(g);
        return false;
    }
}
