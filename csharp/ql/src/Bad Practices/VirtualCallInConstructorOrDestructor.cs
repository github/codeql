class VirtualCallInConstructorOrDestructor
{
    class BaseClass
    {
        protected String classReady = "No";
        public BaseClass()
        {
            Console.WriteLine("Base constructor called.");
            Method();
        }

        public virtual void Method()
        {
            Console.WriteLine("Base method called.");
        }
    }
    class DClass : BaseClass
    {
        public DClass()
        {
            Console.WriteLine("D constructor called.");
            classReady = "Yes";
        }

        public override void Method()
        {
            Console.WriteLine("D method called. Ready for method to be called? " + classReady);
        }
    }
    public static void Main(string[] args)
    {
        BaseClass x = new DClass();
    }
}
