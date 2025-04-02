using System;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Headers;
using Microsoft.AspNetCore.Mvc;

public enum TestEnum
{
    TestEnumValue
}

public class AspController : ControllerBase
{
    public void Action1(string username) // $ Source
    {
        var logger = new ILogger();
        // BAD: Logged as-is
        logger.Warn(username + " logged in"); // $ Alert
    }

    public void Action1(DateTime date)
    {
        var logger = new ILogger();
        // GOOD: DateTime is a sanitizer.
        logger.Warn($"Warning about the date: {date:yyyy-MM-dd}");
    }

    public void Action2(DateTime? date)
    {
        var logger = new ILogger();
        if (date is not null)
        {
            // GOOD: DateTime? is a sanitizer.
            logger.Warn($"Warning about the date: {date:yyyy-MM-dd}");
        }
    }

    public void Action2(bool? b)
    {
        var logger = new ILogger();
        if (b is not null)
        {
            // GOOD: Boolean? is a sanitizer.
            logger.Warn($"Warning about the bool: {b}");
        }
    }

    public void ActionInt(int i)
    {
        var logger = new ILogger();
        // GOOD: int is a sanitizer.
        logger.Warn($"Warning about the int: {i}");
    }

    public void ActionLong(long l)
    {
        var logger = new ILogger();
        // GOOD: long is a sanitizer.
        logger.Warn($"Warning about the long: {l}");
    }

    public void ActionFloat(float f)
    {
        var logger = new ILogger();
        // GOOD: float is a sanitizer.
        logger.Warn($"Warning about the float: {f}");
    }

    public void ActionDouble(double d)
    {
        var logger = new ILogger();
        // GOOD: double is a sanitizer.
        logger.Warn($"Warning about the double: {d}");
    }

    public void ActionDecimal(decimal d)
    {
        var logger = new ILogger();
        // GOOD: decimal is a sanitizer.
        logger.Warn($"Warning about the decimal: {d}");
    }

    public void ActionEnum(TestEnum e)
    {
        var logger = new ILogger();
        // GOOD: Enum is a sanitizer. [FALSE POSITIVE]
        logger.Warn($"Warning about the enum: {e}");
    }

    public void ActionDateTime(DateTimeOffset dt)
    {
        var logger = new ILogger();
        // GOOD: DateTimeOffset is a sanitizer. [FALSE POSITIVE]
        logger.Warn($"Warning about the DateTimeOffset: {dt}");
    }
}
