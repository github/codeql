namespace Semmle.Util.Logging
{
    /// <summary>
    /// A combined logger.
    /// </summary>
    public sealed class CombinedLogger : ILogger
    {
        private readonly ILogger logger1;
        private readonly ILogger logger2;

        public CombinedLogger(ILogger logger1, ILogger logger2)
        {
            this.logger1 = logger1;
            this.logger2 = logger2;
        }

        public void Dispose()
        {
            logger1.Dispose();
            logger2.Dispose();
        }

        public void Log(Severity s, string text, int? threadId = null)
        {
            logger1.Log(s, text, threadId);
            logger2.Log(s, text, threadId);
        }
    }
}
