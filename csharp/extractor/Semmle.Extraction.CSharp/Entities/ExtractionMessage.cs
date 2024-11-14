using System.Collections.Concurrent;
using System.IO;
using System.Threading;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class ExtractionMessage : FreshEntity
    {
        private static readonly int limit = EnvironmentVariables.TryGetExtractorNumberOption<int>("MESSAGE_LIMIT") ?? 10000;

        internal static readonly ConcurrentDictionary<string, int> groupedMessageCounts = [];
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
            // For the time being we're counting the number of messages per severity, we could introduce other groupings in the future
            var key = msg.Severity.ToString();
            groupedMessageCounts.AddOrUpdate(key, 1, (_, c) => c + 1);

            if (!bypassLimit)
            {
                var val = Interlocked.Increment(ref messageCount);
                if (val > limit)
                {
                    if (val == limit + 1)
                    {
                        Context.ExtractionContext.Logger.LogWarning($"Stopped logging extractor messages after reaching {limit}");
                        _ = new ExtractionMessage(Context, new Message($"Stopped logging extractor messages after reaching {limit}", null, null, null, Semmle.Util.Logging.Severity.Warning), bypassLimit: true);
                    }
                    return;
                }
            }

            trapFile.extractor_messages(this, msg.Severity, msg.Text, msg.EntityText ?? string.Empty,
                msg.Location ?? Context.CreateLocation(), msg.StackTrace ?? string.Empty);
        }
    }
}
