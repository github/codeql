class LocalScopeVariableShadowsMember
{
    class C
    {
        protected int f;

        protected virtual void M1(int f) { } // BAD

        int M2(int f) => this.f + f; // GOOD

        void M3()
        {
            var f = ""; // BAD
        }

        void M4()
        {
            var f = this.f; // GOOD
        }
    }

    struct S
    {
        int f;

        void M1(int f) { } // BAD

        int M2(int f) => this.f + f; // GOOD

        void M3()
        {
            var f = ""; // BAD
        }

        void M4()
        {
            var f = this.f; // GOOD
        }
    }

    interface I
    {
        void M5(int f);
    }

    class C2 : C, I
    {
        protected override void M1(int f) { } // BAD

        public void M5(int f) { } // BAD
    }

    class C3 : C, I
    {
        protected override void M1(int f2) { } // GOOD

        public void M5(int f2) { } // GOOD
    }

    class C4 : C
    {
        public C4(int f) { } // GOOD
    }
}
