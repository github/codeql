using System;

class Class
{
    static void Main(string[] args)
    {
        int z = GetParamLength(__arglist(1, 2));
    }

    public static int GetParamLength(__arglist)
    {
        ArgIterator iterator = new ArgIterator(__arglist);
        return iterator.GetRemainingCount();
    }
}
