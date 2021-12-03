class MissedReadonlyOpportunity<T>
{
    public int Bad1;
    public T Bad2;
    public readonly int Good1;
    public readonly int Good2 = 0;
    public const int Good3 = 0;
    public int Good4;
    public readonly T Good5;
    public T Good6;

    public MissedReadonlyOpportunity(int i, T t)
    {
        Bad1 = i;
        Bad2 = t;
        Good1 = i;
        Good2 = i;
        Good4 = i;
        Good5 = t;
        Good6 = t;
    }

    public void M(int i)
    {
        Good4 = i;
        var x = new MissedReadonlyOpportunity<bool>(0, true);
        x.Good6 = false;
    }
}
