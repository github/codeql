namespace Semmle.Extraction.Entities
{
    class ExtractionMessage : FreshEntity
    {
        public ExtractionMessage(Context cx, Message msg) : base(cx)
        {
            cx.TrapWriter.extractor_messages(this, msg.Severity, "C# extractor", msg.Text, msg.EntityText, msg.Location, msg.StackTrace);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }
}
