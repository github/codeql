namespace My.Qltest
{
    public class C
    {
        void Foo()
        {
            object arg1 = new object();
            StepArgRes(arg1);

            object argIn1 = new object();
            object argOut1 = new object();
            StepArgArg(argIn1, argOut1);
            object argIn2 = new object();
            object argOut2 = new object();
            StepArgArg(argIn2, argOut2);

            object arg2 = new object();
            StepArgQual(arg2);
            object arg3 = new object();
            this.StepArgQual(arg3);

            this.StepQualRes();
            StepQualRes();

            object argOut = new object();
            StepQualArg(argOut);

            this.StepFieldGetter();

            this.StepFieldSetter(0);

            this.StepPropertyGetter();

            this.StepPropertySetter(0);

            this.StepElementGetter();

            this.StepElementSetter(0);

            var gen = new Generic<int, int>();
            gen.StepGeneric(0);
            gen.StepGeneric2(false);

            new Sub().StepOverride("string");

            object arg4 = new object();
            Library.StepArgReturnGenerated(arg4);

            object arg5 = new object();
            Library.StepArgReturnGeneratedIgnored(arg5);
        }

        object StepArgRes(object x) { return null; }

        void StepArgArg(object @in, object @out) { }

        void StepArgQual(object x) { }

        object StepQualRes() { return null; }

        void StepQualArg(object @out) { }

        int Field;

        int StepFieldGetter() => throw null;

        void StepFieldSetter(int value) => throw null;

        int Property { get; set; }

        int StepPropertyGetter() => throw null;

        void StepPropertySetter(int value) => throw null;

        int StepElementGetter() => throw null;

        void StepElementSetter(int value) => throw null;

        class Generic<T, U>
        {
            public T StepGeneric(T t) => throw null;

            public T StepGeneric2<S>(S s) => throw null;
        }

        class Base<T>
        {
            public virtual T StepOverride(T t) => throw null;
        }

        class Sub : Base<string>
        {
            public override string StepOverride(string i) => throw null;
        }
    }
}
