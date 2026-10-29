using System;
public class UnsafeYearConstructionBad
{
    public UnsafeYearConstructionBad()
    {
        DateTime Start;
        DateTime End;
        var now = DateTime.UtcNow;
        // the base-date +/- n years may not be a valid date.
        Start = new DateTime(now.Year - 1, now.Month, now.Day, 0, 0, 0, DateTimeKind.Utc);
        End = new DateTime(now.Year + 1, now.Month, now.Day, 0, 0, 1, DateTimeKind.Utc);
    }
}