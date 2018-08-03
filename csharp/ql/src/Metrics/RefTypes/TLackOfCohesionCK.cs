class TLackOfCohesionCK
{
    private int var1;
    private int var2;
    private int var3;
    private int var4;
    private int var5;

    public void methodA()
    {
        var1 = 1;
        Console.WriteLine(var1);
    }
    public void methodB()
    {
        var2 = 1;
        Console.WriteLine(var2);
    }
    public void methodC()
    {
        var3 = 1;
        Console.WriteLine(var3);
    }
    public void methodD()
    {
        var4 = 1;
        Console.WriteLine(var4);
    }
    public void methodE()
    {
        var4 = 1;
        Console.WriteLine(var4);
        var5 = 1;
        Console.WriteLine(var5);
    }
}
