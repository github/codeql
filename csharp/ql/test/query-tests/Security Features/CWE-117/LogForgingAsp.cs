using System;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Headers;
using Microsoft.AspNetCore.Mvc;

public class AspController : ControllerBase
{
    public void Action1(string username)
    {
        var logger = new ILogger();
        // BAD: Logged as-is
        logger.Warn(username + " logged in");
    }

    public void Action1(DateTime date)
    {
        var logger = new ILogger();
        // GOOD: DateTime is a sanitizer.
        logger.Warn($"Warning about the date: {date:yyyy-MM-dd}");
    }
}
