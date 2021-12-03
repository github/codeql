class EqualsUsesAs
{
    class BaseClass
    {
        public override bool Equals(object obj)
        {
            BaseClass objBase = obj as BaseClass;
            return objD != null;
        }
    }

    class DClass : BaseClass
    {
        public override bool Equals(object obj)
        {
            DClass objD = obj as DClass;
            return objD != null;
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
