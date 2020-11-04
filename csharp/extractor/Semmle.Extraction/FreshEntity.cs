using System.IO;

namespace Semmle.Extraction
{
    /// <summary>
    /// An entity which has a default "*" ID assigned to it.
    /// </summary>
    public abstract class FreshEntity : IEntity
    {
        protected Context cx { get; }

        protected FreshEntity(Context cx)
        {
            this.cx = cx;
            cx.AddFreshLabel(this);
        }

        public Label Label
        {
            get; set;
        }

        public void WriteId(TextWriter writer)
        {
            writer.Write('*');
        }

        public void WriteQuotedId(TextWriter writer)
        {
            WriteId(writer);
        }

        protected abstract void Populate(TextWriter trapFile);

        protected void TryPopulate()
        {
            cx.Try(null, null, () => Populate(cx.TrapWriter.Writer));
        }

        /// <summary>
        /// For debugging.
        /// </summary>
        public string DebugContents
        {
            get
            {
                using var writer = new StringWriter();
                Populate(writer);
                return writer.ToString();
            }
        }

        public override string ToString() => Label.ToString();

        public virtual Microsoft.CodeAnalysis.Location? ReportingLocation => null;

        public abstract TrapStackBehaviour TrapStackBehaviour { get; }
    }
}
