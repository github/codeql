namespace My.Qltest
{
    public class A
    {
        void Foo()
        {
            object x;
            x = Src1();
            x = Src1("");

            Sub sub = new Sub();
            x = sub.Src2();
            x = sub.Src3();

            SrcArg(x);

            x = TaggedSrcMethod();
            x = TaggedSrcField;

            x = SrcTwoArg("", "");

            x = TaggedSrcPropertyGetter;
            x = this[0];
        }

        [SourceAttribute]
        void Tagged1(object taggedMethodParam)
        {
        }

        void Tagged2([SourceAttribute] object taggedSrcParam)
        {
        }

        object Src1() { return null; }

        object Src1(string s) { return null; }

        object Src2() { return null; }

        public virtual object Src3() { return null; }

        public virtual void SrcParam(object p) { }

        class Sub : A
        {
            // inherit src2
            public override object Src3() { return null; }

            public override void SrcParam(object p) { }
        }

        void SrcArg(object src) { }

        [SourceAttribute]
        object TaggedSrcMethod() { return null; }

        [SourceAttribute]
        object TaggedSrcField;

        object SrcTwoArg(string s1, string s2) { return null; }

        [SourceAttribute]
        object TaggedSrcPropertyGetter { get; }

        [SourceAttribute]
        object this[int i] => null;
    }

    class SourceAttribute : System.Attribute { }
}
