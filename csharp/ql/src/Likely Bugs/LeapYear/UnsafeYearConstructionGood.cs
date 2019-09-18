using System;
public class UnsafeYearConstructionGood
{
    public UnsafeYearConstructionGood()
    {
        DateTime Start;
        DateTime End;
        var now = DateTime.UtcNow;
        Start = now.AddYears(-1).Date;
        End = now.AddYears(-1).Date.AddSeconds(1);
    }
}