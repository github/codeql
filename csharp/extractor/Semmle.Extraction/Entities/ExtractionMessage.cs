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
            var val = Interlocked.Increment(ref messageCount);
            if (val > limit)
            {
                if (val == limit + 1)
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
