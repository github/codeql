class TypeAccesses
{
    void M(object o)
    {
        var s = (string)o;
        s = o as string;
        if (o is int j) ;
        var t = typeof(int);
    }
}
