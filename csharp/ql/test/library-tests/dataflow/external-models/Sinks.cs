namespace My.Qltest
{
    public class B
    {
        void Foo()
        {
            object arg1 = new object();
            Sink1(arg1);

            object argToTagged = new object();
            TaggedSinkMethod(argToTagged);

            object fieldWrite = new object();
            TaggedField = fieldWrite;
        }

        object SinkMethod()
        {
            object res = new object();
            return res;
        }

        [SinkAttribute]
        object TaggedSinkMethod()
        {
            object resTag = new object();
            return resTag;
        }

        void Sink1(object x) { }

        [SinkAttribute]
        void TaggedSinkMethod(object x) { }

        [SinkAttribute]
        object TaggedField;
    }

    class SinkAttribute : System.Attribute { }
}