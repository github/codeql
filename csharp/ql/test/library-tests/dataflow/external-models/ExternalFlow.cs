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
            this.StepFieldSetter(new object());
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

        object StepArgRes(object x) { return null; }

        void StepArgArg(object @in, object @out) { }

        void StepArgQual(object x) { }

        object StepQualRes() { return null; }

        void StepQualArg(object @out) { }

        object Field;

        object StepFieldGetter() => throw null;

        void StepFieldSetter(object value) => throw null;

        object Property { get; set; }

        object StepPropertyGetter() => throw null;

        void StepPropertySetter(object value) => throw null;

        object StepElementGetter() => throw null;

        void StepElementSetter(object value) => throw null;

        static T Apply<S, T>(Func<S, T> f, S s) => throw null;

        static S[] Map<S, T>(S[] elements, Func<S, T> f) => throw null;

        static void Parse(string s, out int i) => throw null;

        static void Sink(object o) { }
    }
}