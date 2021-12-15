using System.Collections.Generic;

public class Delegates {
    delegate int Del(int num);

    static int returns(int ret)
    {
        return ret;
    }
    
    public static void Main() {
        Del del1 = new Del(returns);
        del1(5);
    }
}
