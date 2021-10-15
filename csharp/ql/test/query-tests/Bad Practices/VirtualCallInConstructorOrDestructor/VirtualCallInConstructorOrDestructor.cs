using System;

namespace TestVirtualCalls
{
    interface I
    {
        void f_interface();
    }

    class A : I
    {
        public virtual void f_virtual() { }
        public virtual void f_sealed() { }
        public void f_nonvirtual() { }
        public void f_interface() { }

        public virtual int p_virtual { get { return 0; } }
        public virtual int p_sealed { get { return 0; } }
        public int p_nonvirtual { get { return 0; } }

        public virtual int this[int x] { get { return 0; } }
        public virtual int this[string x] { get { return 0; } }
        public int this[object x] { get { return 0; } }

        public delegate void Del();

        public virtual event Del e_virtual;
        public virtual event Del e_sealed;
        public event Del e_nonvirtual;
    };

    class B : A
    {
        public sealed override void f_sealed() { }
        public sealed override int p_sealed { get { return 0; } }
        public sealed override int this[string x] { get { return 0; } }
        public sealed override event Del e_sealed;
    }

    class C : B
    {
        C()
        {
            // Method call
            f_virtual();        // BAD
            f_sealed();         // GOOD
            f_nonvirtual();       // GOOD
            f_interface();        // GOOD
            ((I)this).f_interface(); // GOOD

            // Method access
            Action a;
            a = f_virtual;  // BAD
            a = f_sealed; // GOOD
            a = f_nonvirtual; // GOOD
            a = f_interface;  // GOOD

            // Property access
            int i = p_virtual;  // BAD
            i = p_sealed;   // GOOD
            i = p_nonvirtual; // GOOD

            // Indexer access
            i = this[0];  // BAD
            i = this[""]; // GOOD
            i = this[new object()]; // GOOD

            // Event access
            e_virtual += f_nonvirtual;  // BAD
            e_sealed += f_nonvirtual; // GOOD
            e_nonvirtual += f_nonvirtual; // GOOD
        }
    }
}
