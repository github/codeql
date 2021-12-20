using Microsoft.CodeAnalysis;
using System;
using System.IO;

namespace Semmle.Extraction
{
    public abstract class Entity : IEntity
    {
        public virtual Context Context { get; }

        protected Entity(Context context)
        {
            this.Context = context;
        }

        public Label Label { get; set; } = new Label(-1);

        public abstract void WriteId(EscapingTextWriter trapFile);

        public virtual void WriteQuotedId(EscapingTextWriter trapFile)
        {
            trapFile.WriteUnescaped("@\"");
            WriteId(trapFile);
            trapFile.WriteUnescaped('\"');
        }

        public abstract Location? ReportingLocation { get; }

        public abstract TrapStackBehaviour TrapStackBehaviour { get; }

        public void DefineLabel(TextWriter trapFile, Extractor extractor)
        {
            trapFile.WriteLabel(this);
            trapFile.Write("=");
            using var escaping = new EscapingTextWriter(trapFile);
            try
            {
                WriteQuotedId(escaping);
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                trapFile.WriteLine("\"");
                extractor.Message(new Message($"Unhandled exception generating id: {ex.Message}", ToString() ?? "", null, ex.StackTrace));
            }
            trapFile.WriteLine();
        }

        public void DefineFreshLabel(TextWriter trapFile)
        {
            trapFile.WriteLabel(this);
            trapFile.WriteLine("=*");
        }

        public virtual Label GetLabelForWriter(TextWriter trapFile) => Label;

        public override string ToString() => Label.ToString();
    }
}
