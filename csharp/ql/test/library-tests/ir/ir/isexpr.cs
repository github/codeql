public class Is_A 
{
    public int x;
}

public class IsExpr 
{
    public static void Main() 
    {
        Is_A obj = null;

        object o = obj;
        if (o is Is_A tmp) 
        {
            int res = tmp.x;
        }
        if (o is Is_A) 
        {
            
        } 
    }
}
