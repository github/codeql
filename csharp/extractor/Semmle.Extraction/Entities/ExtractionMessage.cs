using System.IO;
using System.Threading;
using Semmle.Util;

namespace Semmle.Extraction.Entities
{
    internal class ExtractionMessage : FreshEntity
    {
        private static readonly int limit = EnvironmentVariables.TryGetExtractorNumberOption<int>("MESSAGE_LIMIT") ?? 10000;
        private static int messageCount = 0;

        private readonly Message msg;
        private readonly bool bypassLimit;

        public ExtractionMessage(Context cx, Message msg) : this(cx, msg, bypassLimit: false)
        {
        }

        private ExtractionMessage(Context cx, Message msg, bool bypassLimit) : base(cx)
        {
            this.bypassLimit = bypassLimit;
            this.msg = msg;
            TryPopulate();
        }

        protected override void Populate(TextWriter trapFile)
        {
            if (!bypassLimit)
            {
                var val = Interlocked.Increment(ref messageCount);
                if (val > limit)
                {
                    if (val == limit + 1)
                    {
                        Context.ExtractionContext.Logger.LogWarning($"Stopped logging extractor messages after reaching {limit}");
                        _ = new ExtractionMessage(Context, new Message($"Stopped logging extractor messages after reaching {limit}", null, null, null, Util.Logging.Severity.Warning), bypassLimit: true);
                    }
                    return;
                }
            }

            trapFile.extractor_messages(this, msg.Severity, msg.Text, msg.EntityText ?? string.Empty,
                msg.Location ?? Context.CreateLocation(), msg.StackTrace ?? string.Empty);
        }
    }
}
