using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal class ProgressMonitor : IProgressMonitor
    {
        private readonly ILogger logger;

        public ProgressMonitor(ILogger logger)
        {
            this.logger = logger;
        }

        public void Log(Severity severity, string message) =>
            logger.Log(severity, message);

        public void LogInfo(string message, int? threadId = null) =>
            logger.Log(Severity.Info, message, threadId);

        public void LogDebug(string message) =>
            logger.Log(Severity.Debug, message);

        public void LogError(string message, int? threadId = null) =>
            logger.Log(Severity.Error, message, threadId);
    }
}
