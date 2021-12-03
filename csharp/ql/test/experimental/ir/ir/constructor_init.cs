public class BaseClass
{
    int num;

    public BaseClass()
    {
    }

    public BaseClass(int i)
    {
        num = i;
    }
}

public class DerivedClass : BaseClass
{
    public DerivedClass() : base()
    {
    }

    public DerivedClass(int i) : base(i)
    {
    }

    public DerivedClass(int i, int j): this(i) 
    {
    }

    static void Main()
    {
        DerivedClass obj1 = new DerivedClass();
        DerivedClass obj2 = new DerivedClass(1);
        DerivedClass obj3 = new DerivedClass(1, 2);
    }
}
