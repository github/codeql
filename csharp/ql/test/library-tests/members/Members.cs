namespace Types
{
    /*internal*/
    class Class
    {
        /*private*/
        class NestedClass { }

        /*private*/
        void Method() { }
    }

    internal class Class2
    {
        private class NestedClass2 { }

        private void Method2() { }
    }

    /*internal*/
    interface Interface { }

    internal interface Interface2 { }

    /*internal*/
    enum Enum { }

    enum Enum2 { }

    /*internal*/
    struct Struct { }

    struct Struct2 { }
}
