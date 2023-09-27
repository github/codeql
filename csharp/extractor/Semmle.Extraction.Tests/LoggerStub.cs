using Semmle.Util.Logging;

namespace Semmle.Extraction.Tests
{
    internal class LoggerStub : ILogger
    {
        public void Log(Severity severity, string message) { }

        public void Dispose() { }
    }
}
