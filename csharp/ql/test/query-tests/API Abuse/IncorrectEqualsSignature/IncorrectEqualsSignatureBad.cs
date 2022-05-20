using System;

class Bad
{
    private int id;

    public Bad(int Id)
    {
        this.id = Id;
    }

    public bool Equals(Bad b) =>
      this.id == b.id;
}
