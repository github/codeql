class MyClass {
    public int fld;
}

struct MyStruct {
    public int fld;
}

class InOutRef
{
    static void set(ref MyClass o1, MyClass o2)
    {   
        o1 = o2;
    }

    static void F(ref int a, ref MyStruct b, in MyStruct b1, ref MyClass c, in MyClass c1) 
    {
        b.fld = 0;
        a = b.fld;

        c.fld = 10;
        a = c.fld;

        b = b1;

        set(ref c, c1);
    }

    static void Main() 
    {
        int a = 0;
        MyStruct b = new MyStruct();
        MyClass c = new MyClass();
        F(ref a, ref b, in b, ref c, in c);

        int x = b.fld;
    }
}
