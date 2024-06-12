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

        public ExtractionMessage(Context cx, Message msg) : base(cx)
        {
            this.msg = msg;
            TryPopulate();
        }

        protected override void Populate(TextWriter trapFile)
        {
            // The below doesn't limit the extractor messages to the exact limit, but it's good enough.
            Interlocked.Increment(ref messageCount);
            if (messageCount > limit)
            {
                if (messageCount == limit + 1)
                {
                    Context.ExtractionContext.Logger.LogWarning($"Stopped logging extractor messages after reaching {limit}");
                }
                return;
            }

            trapFile.extractor_messages(this, msg.Severity, "C# extractor", msg.Text, msg.EntityText ?? string.Empty,
                msg.Location ?? Context.CreateLocation(), msg.StackTrace ?? string.Empty);
        }
    }
}
