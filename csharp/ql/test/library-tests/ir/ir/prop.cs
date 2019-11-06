class PropClass 
{
    private static int prop;

    public int Prop
    { 
        get 
        {
            return func();
        }

        set 
        {
            prop = value;
        }
    }

    private int func() 
    {
        return 0;
    }
}

class Prog 
{
    public static void Main() 
    {
        PropClass obj = new PropClass();
        obj.Prop = 5;
        int x = obj.Prop;
    }
}
