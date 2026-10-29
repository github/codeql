using System;

namespace CallTargets
{
    class C1
    {
        public virtual void m() { }
    }

    class C2 : C1
    {
        public override void m()
        {
            var c2 = new C2();
            c2.m();
            this.m();
            base.m();
        }
    }

    class C3 : C2
    {
        public override void m()
        {
            var c3 = new C3();
            c3.m();
            this.m();
            base.m();
        }
    }
}
