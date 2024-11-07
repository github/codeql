using System;

namespace Semmle.Util.Logging
{
    /// <summary>
    /// A logger.
    /// </summary>
    public interface ILogger : IDisposable
    {
        /// <summary>
        /// Log the given text with the given severity.
        /// </summary>
        void Log(Severity s, string text, int? threadId = null);

        void LogError(string text, int? threadId = null) => Log(Severity.Error, text, threadId);

        void LogWarning(string text, int? threadId = null) => Log(Severity.Warning, text, threadId);

        void LogInfo(string text, int? threadId = null) => Log(Severity.Info, text, threadId);

        void LogDebug(string text, int? threadId = null) => Log(Severity.Debug, text, threadId);

        void LogTrace(string text, int? threadId = null) => Log(Severity.Trace, text, threadId);
    }
}
