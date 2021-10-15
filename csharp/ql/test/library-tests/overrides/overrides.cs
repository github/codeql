using System;
using System.IO;
using System.Collections.Generic;

namespace overrides
{

    public class C : List<int>
    {

        protected virtual void f2()
        {
            Console.WriteLine("C.f2()");
            Add(2);
        }

        protected virtual void f3()
        {
            Console.WriteLine("C.f3()");
            Add(3);
        }

        protected virtual void f4()
        {
            Console.WriteLine("C.f4()");
            Add(4);
        }

        protected virtual void f5()
        {
            Console.WriteLine("C.f5()");
            Add(5);
        }

        public override string ToString()
        {
            return "C";
        }

        protected virtual string P4 { get; set; }
    }

    public abstract class B : C
    {

        private void f1()
        {
            Console.WriteLine("B.f1()");
        }

        protected virtual void f2()
        {  // does not override C.f2()
            Console.WriteLine("B.f2()");
        }

        protected new virtual void f3()
        { // does not override C.f3()
            Console.WriteLine("B.f3()");
        }

        private void f4()
        { // does not override C.f4()
            Console.WriteLine("B.f4()");
        }

        protected override void f5()
        { // overrides C.f5()
            Console.WriteLine("B.f5()");
        }

        internal abstract void f6();

        protected virtual internal string P1 { get; set; }

        protected virtual string P2 { get { return ""; } set { } }

        protected abstract string P3 { get; set; }

        private string P4 { get; set; }

        public virtual event EventHandler E1;

    }

    public class A : B
    {

        public void f1()
        { // does not override B.f1()
            Console.WriteLine("A.f1()");
        }

        protected override void f2()
        { // overrides B.f2()
            Console.WriteLine("A.f2()");
        }

        protected override void f3()
        { // overrides B.f3()
            Console.WriteLine("A.f3()");
        }

        protected override void f4()
        { // overrides C.f4(), B.f4() being private
            Console.WriteLine("A.f4()");
        }

        protected override void f5()
        { // overrides B.f5()
            Console.WriteLine("A.f5()");
        }

        internal override void f6()
        { // overrides B.f6()
            Console.WriteLine("A.f6()");
        }

        protected internal override string P1 { get { return ""; } set { } } // overrides B.P1

        protected override string P2 { get { return ""; } } // overrides B.P2

        protected override string P3 { get; set; } // overrides B.P3

        protected override string P4 { get { return ""; } set { } } // overrides C.P4

        public override event EventHandler E1;

    }

    public class D : A
    {
        protected override void f2() { } // overrides A.f2()

        public override string ToString()
        { //overrides C.ToString()
            return "D";
        }
    }

    public interface I
    {
        void M();
    }

    public class E : I
    {
        public virtual void M() { } // implements I.M()
    }

    public class E2 : E
    {
        public override void M() { } // overrides E.M()
    }

    public class F : I
    {
        void I.M() { } // implements I.M()
    }

    public interface I2<T>
    {
        S M<S>(T x, S y);
    }

    public class G : I2<string>
    {
        public virtual S M<S>(string x, S y) { return y; } // implements I2<string>.M()
    }

    public class G2 : G
    {
        public override S M<S>(string x, S y) { return y; } // overrides G.M()
    }

    public class H<TA> : I2<TA>
    {
        S I2<TA>.M<S>(TA x, S y) { return y; } // implements I2<TA>.M()
    }

    public interface I3
    {
        string Prop { get; set; }
    }

    abstract class C1
    {
        public abstract string Prop { get; set; }
    }

    class C2 : C1, I3
    {
        public override string Prop { get { return ""; } set { } } // overrides C1.Prop
        string I3.Prop { get { return ""; } set { } } // implements I3.Prop
    }

    interface I4 : I3
    {
        void Method();
        [System.Runtime.CompilerServices.IndexerName("MyIndexer")]
        string this[int i] { get; set; }
    }

    class C3<T> : I4
    {
        public string Prop { get; set; }
        public void Method() { }
        public string this[int i] { get { return ""; } set { } }
    }

    class C4 : C3<int> { }

    public delegate void EventHandler(object sender, object e);

    interface I5 : I2<object[]>
    {
        int Property { get; set; }
        int this[int x] { get; }
        event EventHandler Event;
    }

    class A1
    {
        public virtual T M<T>(dynamic[] x, T y) { return y; } // implements I2<object[]>.M (via A2)
        public virtual int Property { get; set; } // implements I5.Property (via A2)
        public virtual int this[int x] { get { return x; } } // implements I5.Item (via A2)
        public virtual event EventHandler Event; // implements I5.Event (via A2)
    }

    class A2 : A1, I5 { }

    class A3 : A2
    {
        new public T M<T>(object[] x, T y) { return y; }
        new public int Property { get; set; }
        new public int this[int x] { get { return x; } }
        new public event EventHandler Event;
    }

    class A4 : A3, I5
    {
        T I2<object[]>.M<T>(dynamic[] x, T y) { return y; } // implements I2<object[]>.M
        int I5.Property { get; set; } // implements I5.Property
        int I5.this[int x] { get { return x; } } // implements I5.Item
        event EventHandler I5.Event { add { } remove { } } // implements I5.Event
    }

    class A6 : A1
    {
        new public T M<T>(object[] x, T y) { return y; } // implements I2<object[]>.M (via A7)
        new public int Property { get; set; } // implements I5.Property (via A7)
        new public int this[int x] { get { return x; } } // implements I5.M (via A7)
        new public event EventHandler Event; // implements I5.Event (via A7)
    }

    class A7 : A6, I5 { }

    class A8 : A1
    {
        public override T M<T>(dynamic[] x, T y) { return y; } // overrides A1.M
        public override int Property { get; set; } // overrides A1.Property
        public override int this[int x] { get { return x; } } // overrides A1.Item
        public override event EventHandler Event; // overrides A1.Event
    }

    class A9 : A2
    {
        public override T M<T>(dynamic[] x, T y) { return y; } // overrides A2.M
        public override int Property { get; set; } // overrides A2.Property
        public override int this[int x] { get { return x; } } // overrides A2.Item
        public override event EventHandler Event; // overrides A2.Event
    }

    class Outer<T>
    {
        class Inner { }

        interface I6
        {
            void M<T>(Outer<T>.Inner x);
        }

        class A10
        {
            public void M<T>(Outer<T>.Inner x) { } // implements I6.M (via A11)
        }

        class A11 : A10, I6 { }
    }
}
