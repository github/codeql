using Semmle.Util.Logging;
using System;

namespace Semmle.BuildAnalyser.PowerShell
{
    /// <summary>
    /// Callback for various events that may happen during the build analysis.
    /// </summary>
    internal interface IProgressMonitor
    {
        void FindingFiles(string dir);
        void Log(Severity severity, string message);
        void CommandFailed(string exe, string arguments, int exitCode);
    }

    internal class ProgressMonitor : IProgressMonitor
    {
        private readonly ILogger logger;

        public ProgressMonitor(ILogger logger)
        {
            this.logger = logger;
        }

        public void FindingFiles(string dir)
        {
            logger.Log(Severity.Info, "Finding files in {0}...", dir);
        }

        public void Log(Severity severity, string message)
        {
            logger.Log(severity, message);
        }

        public void CommandFailed(string exe, string arguments, int exitCode)
        {
            logger.Log(Severity.Error, $"Command {exe} {arguments} failed with exit code {exitCode}");
        }
    }
}
