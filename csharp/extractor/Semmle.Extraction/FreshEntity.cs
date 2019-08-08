using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction
{
    /// <summary>
    /// An entity which has a default "*" ID assigned to it.
    /// </summary>
    public abstract class FreshEntity : IEntity
    {
        protected readonly Context cx;

        public FreshEntity(Context cx)
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

        public override string ToString() => Label.ToString();

        public IId Id => FreshId.Instance;

        public virtual Microsoft.CodeAnalysis.Location ReportingLocation => null;

        public abstract TrapStackBehaviour TrapStackBehaviour { get; }
    }
}
