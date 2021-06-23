using System.IO;

namespace Semmle.Extraction.Entities
{
    internal class ExtractionMessage : FreshEntity
    {
        private readonly Message msg;

        public ExtractionMessage(Context cx, Message msg) : base(cx)
        {
            this.msg = msg;
            TryPopulate();
        }

        protected override void Populate(TextWriter trapFile)
        {
            trapFile.extractor_messages(this, msg.Severity, "C# extractor", msg.Text, msg.EntityText ?? string.Empty,
                msg.Location ?? Context.CreateLocation(), msg.StackTrace ?? string.Empty);
        }
    }
}
