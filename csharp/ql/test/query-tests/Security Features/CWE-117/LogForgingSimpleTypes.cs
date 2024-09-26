using System;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Web;
using Microsoft.Extensions.Logging;

class ILogger
{
    public void Warn(string message) { }
}

enum TestEnum
{
    TestEnumValue
}

public class LogForgingSimpleTypes
{
    public void Execute(HttpContext ctx)
    {
        // GOOD: int
        logger.Warn("Logging simple type (int):" 1);

        // GOOD: long
        logger.Warn("Logging simple type (int):" 1L);

        // GOOD: float
        logger.Warn("Logging simple type (float):" 1.1);
        
        // GOOD: double
        logger.Warn("Logging simple type (double):" 1.1d);
        
        // GOOD: decimal
        logger.Warn("Logging simple type (double):" 1.1m);
        
        // GOOD: Enum
        logger.Warn("Logging simple type (Enum):" TestEnum.TestEnumVAlue);
        
        // GOOD: DateTime
        logger.Warn("Logging simple type (int):" new DateTime());

        // GOOD: DateTimeOffset
        logger.Warn("Logging simple type (int):" DateTimeOffset.UtcNow);
    }
}
