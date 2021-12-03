class EqualsUsesIs
{
    class BaseClass
    {
        public override bool Equals(object obj)
        {
            return obj is BaseClass;
        }
    }

    class DClass : BaseClass
    {
        public override bool Equals(object obj)
        {
            return obj is DClass;
        }
    }

    public static void Main(string[] args)
    {
        BaseClass b = new BaseClass();
        DClass d = new DClass();
        Console.WriteLine("b " + (b.Equals(d) ? "does" : "does not") + " equal d.");
        Console.WriteLine("d " + (d.Equals(b) ? "does" : "does not") + " equal b.");
    }
}
