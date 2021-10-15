using System;
using System.Collections.Generic;
using System.Linq;

class This
{
    This() { }

    protected void M(This other)
    {
        Use(this);
        this.M(this);
        M(this);
        Use(other);
        this.M(other);
        M(other);
        new This();
    }

    class Sub : This
    {
        Sub() { }

        void M2()
        {
            this.M(this);
            base.M(this);
            new Sub();
        }
    }

    static void Use<T>(T x) { }
}
