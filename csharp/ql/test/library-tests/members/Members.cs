namespace Types
{
    public delegate void EventHandler(object sender, object e);

    /*internal*/
    class Class
    {
        /*private*/
        class NestedClass
        {
            /*private*/
            string Method<T>(T t) => t.ToString();
            /*private*/
            string this[int i] { get => i.ToString(); set { } }
            /*private*/
            string Field;
            /*private*/
            string Prop { get; set; }
            /*private*/
            event EventHandler Event;
        }

        /*private*/
        void Method() { }
        /*private*/
        string this[int i] { get => i.ToString(); set { } }
        /*private*/
        string Field;
        /*private*/
        string Prop { get; set; }
        /*private*/
        event EventHandler Event;
    }

    internal class Class2
    {
        private class NestedClass2
        {
            private string Method<T>(T t) => t.ToString();
            private string this[int i] { get => i.ToString(); set { } }
            private string Field;
            private string Prop { get; set; }
            private event EventHandler Event;
        }

        private void Method() { }
        private string this[int i] { get => i.ToString(); set { } }
        private string Field;
        private string Prop { get; set; }
        private event EventHandler Event;
    }

    /*internal*/
    interface Interface
    {
        void Method();
        string this[int i] { get; set; }
        string Prop { get; set; }
        event EventHandler Event;
    }

    internal interface Interface2
    {
        void Method();
        string this[int i] { get; set; }
        string Prop { get; set; }
        event EventHandler Event;
    }

    /*internal*/
    enum Enum { }

    enum Enum2 { }

    /*internal*/
    struct Struct { }

    struct Struct2 { }
}
