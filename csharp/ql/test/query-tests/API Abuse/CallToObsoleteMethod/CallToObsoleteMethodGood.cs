using System;

class Good
{
    void M()
    {
        Logger.Log(LogLevel.Info, "Hello, World!");
    }

    static class Logger
    {
        [Obsolete("Use Log(LogLevel level, string s) instead")]
        public static void Log(string s)
        {
            // ...
        }

        public static void Log(LogLevel level, string s)
        {
            // ...
        }
    }

    enum LogLevel
    {
        Info,
        Warning,
        Error
    }
}
