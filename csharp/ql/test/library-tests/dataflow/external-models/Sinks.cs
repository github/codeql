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

            object propertyWrite = new object();
            TaggedPropertySetter = propertyWrite;

            object indexerWrite = new object();
            this[0] = indexerWrite;
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

        [SinkPropertyAttribute]
        object TaggedPropertySetter { get; set; }

        [SinkIndexerAttribute]
        object this[int index]
        {
            get { return null; }
            set { }
        }
    }

    class SinkAttribute : System.Attribute { }

    class SinkPropertyAttribute : System.Attribute { }

    class SinkIndexerAttribute : System.Attribute { }
}
