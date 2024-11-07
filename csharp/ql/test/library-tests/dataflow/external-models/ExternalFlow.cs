using System;

namespace My.Qltest
{
    public class D
    {
        void M1()
        {
            object arg1 = new object();
            Sink(StepArgRes(arg1));
        }

        void M2()
        {
            object argIn1 = new object();
            object argOut1 = new object();
            StepArgArg(argIn1, argOut1);
            Sink(argOut1);
        }

        void M3()
        {
            object arg2 = new object();
            StepArgQual(arg2);
            Sink(this);
        }

        void M4()
        {
            this.Field = new object();
            Sink(this.StepFieldGetter());
        }

        void M5()
        {
            Sink(((D)this.StepFieldSetter(new object()).Field2).Field);
            Sink(this.Field);
        }

        void M6()
        {
            this.Property = new object();
            Sink(this.StepPropertyGetter());
        }

        void M7()
        {
            this.StepPropertySetter(new object());
            Sink(this.Property);
        }

        void M8()
        {
            this.StepElementSetter(new object());
            Sink(this.StepElementGetter());
        }

        void M9()
        {
            Apply<object, object>(o => { Sink(o); return o; }, new object());
        }

        void M10()
        {
            var o = Apply<int, object>(_ => new object(), 0);
            Sink(o);
        }

        void M11()
        {
            var objs = new[] { new object() };
            Map(objs, o => { Sink(o); return o; });
        }

        void M12()
        {
            var objs = Map(new[] { 0 }, _ => new object());
            Sink(objs[0]);
        }

        void M13()
        {
            var objs = new[] { new object() };
            var objs2 = Map(objs, o => o);
            Sink(objs2[0]);
        }

        void M14()
        {
            var s = new string("");
            Parse(s, out var i);
            Sink(i);
        }

        void M15()
        {
            var d1 = new D();
            d1.Field = new object();
            var d2 = new D();
            Apply2(d =>
            {
                Sink(d);
            }, d1, d2);
            Sink(d1.Field);
            Sink(d2.Field2);
        }

        void M16()
        {
            var f = new F();
            f.MyProp = new object();
            Sink(f.MyProp);
        }

        void M17()
        {
            var a = new object[] { new object() };
            var b = Reverse(a);
            Sink(b); // No flow
            Sink(b[0]); // Flow
        }

        object StepArgRes(object x) { return null; }

        void StepArgArg(object @in, object @out) { }

        void StepArgQual(object x) { }

        object StepQualRes() { return null; }

        void StepQualArg(object @out) { }

        object Field;
        object Field2;

        object StepFieldGetter() => throw null;

        D StepFieldSetter(object value) => throw null;

        object Property { get; set; }

        object StepPropertyGetter() => throw null;

        void StepPropertySetter(object value) => throw null;

        object StepElementGetter() => throw null;

        void StepElementSetter(object value) => throw null;

        static T Apply<S, T>(Func<S, T> f, S s) => throw null;

        static T[] Map<S, T>(S[] elements, Func<S, T> f) => throw null;

        static void Apply2(Action<object> f, D d1, D d2) => throw null;

        static void Parse(string s, out int i) => throw null;

        static object[] Reverse(object[] elements) => throw null;

        static void Sink(object o) { }
    }

    public class E
    {
        object MyField;

        public virtual object MyProp
        {
            get { throw null; }
            set { throw null; }
        }
    }

    public class F : E
    {
        public override object MyProp
        {
            get { throw null; }
            set { throw null; }
        }
    }

    public class G
    {
        void M1()
        {
            var o = new object();
            Sink(GeneratedFlow(o)); // no flow because the modelled method exists in source code
        }

        void M2()
        {
            var o1 = new object();
            Sink(GeneratedFlowArgs(o1, null)); // no flow because the modelled method exists in source code

            var o2 = new object();
            Sink(GeneratedFlowArgs(null, o2)); // no flow because the modelled method exists in source code
        }

        void M3()
        {
            var o1 = new object();
            Sink(Library.MixedFlowArgs(o1, null));

            var o2 = new object();
            Sink(Library.MixedFlowArgs(null, o2));
        }

        void M4()
        {
            var o1 = new object();
            Sink(Library.GeneratedFlowWithGeneratedNeutral(o1));

            var o2 = new object();
            Sink(Library.GeneratedFlowWithManualNeutral(o2)); // no flow because the modelled method has a manual neutral summary model
        }

        object GeneratedFlow(object o) => throw null;

        object GeneratedFlowArgs(object o1, object o2) => throw null;

        static void Sink(object o) { }
    }

    public interface HI { }

    public class HC : HI { }

    public static class HE
    {
        public static object ExtensionMethod(this HI h) => throw null;
    }

    public class H
    {
        void M1()
        {
            var h = new HC();
            var o = h.ExtensionMethod();
            Sink(o);
        }

        static void Sink(object o) { }
    }

    [System.Runtime.CompilerServices.InlineArray(10)]
    public struct MyInlineArray
    {
        private object myInlineArrayElements;
    }

    public class I
    {
        void M1(MyInlineArray a)
        {
            a[0] = new object();
            var b = GetFirst(a);
            Sink(b);
        }

        object GetFirst(MyInlineArray arr) => throw null;

        static void Sink(object o) { }
    }

    public class J
    {
        public virtual object Prop1 { get; }

        public virtual void SetProp1(object o) => throw null;

        public virtual object Prop2 { get; }

        public virtual void SetProp2(object o) => throw null;

        void M1()
        {
            var j = new object();
            SetProp1(j);
            // flow as there is a manual summary.
            Sink(this.Prop1);
        }

        void M2()
        {
            var j = new object();
            SetProp2(j);
            // no flow as there is only a generated summary and source code is available.
            Sink(this.Prop2);
        }

        static void Sink(object o) { }
    }

    // Test synthetic fields
    public class K
    {

        public object MyField;

        public void SetMySyntheticField(object o) => throw null;

        public object GetMySyntheticField() => throw null;

        public void SetMyNestedSyntheticField(object o) => throw null;

        public object GetMyNestedSyntheticField() => throw null;

        public void SetMyFieldOnSyntheticField(object o) => throw null;

        public object GetMyFieldOnSyntheticField() => throw null;

        public void M1()
        {
            var o = new object();
            SetMySyntheticField(o);
            Sink(GetMySyntheticField());
        }

        public void M2()
        {
            var o = new object();
            SetMyNestedSyntheticField(o);
            Sink(GetMyNestedSyntheticField());
        }

        public void M3()
        {
            var o = new object();
            SetMyFieldOnSyntheticField(o);
            Sink(GetMyFieldOnSyntheticField());
        }

        static void Sink(object o) { }
    }

    // Test content data flow provenance.
    public class L
    {
        public void M1()
        {
            var l = new Library();
            var o = new object();
            l.SetValue(o);
            Sink(l.GetValue());
        }

        static void Sink(object o) { }
    }

}
