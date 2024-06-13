using System;
using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction
{
    public abstract class Entity : IEntity
    {
        public virtual Context Context { get; }

        protected Entity(Context context)
        {
            this.Context = context;
        }

        public Label Label { get; set; }

        public abstract void WriteId(EscapingTextWriter trapFile);

        public virtual void WriteQuotedId(EscapingTextWriter trapFile)
        {
            trapFile.WriteUnescaped("@\"");
            WriteId(trapFile);
            trapFile.WriteUnescaped('\"');
        }

        public abstract Location? ReportingLocation { get; }

        public abstract TrapStackBehaviour TrapStackBehaviour { get; }

        public void DefineLabel(TextWriter trapFile)
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
                Context.ExtractionContext.Message(new Message($"Unhandled exception generating id: {ex.Message}", ToString() ?? "", null, ex.StackTrace));
            }
            trapFile.WriteLine();
        }

        public void DefineFreshLabel(TextWriter trapFile)
        {
            trapFile.WriteLabel(this);
            trapFile.WriteLine("=*");
        }

#if DEBUG_LABELS
        /// <summary>
        /// Generates a debug string for this entity.
        /// </summary>
        public string GetDebugLabel()
        {
            using var writer = new EscapingTextWriter();
            writer.WriteLabel(Label.Value);
            writer.Write('=');
            WriteQuotedId(writer);
            return writer.ToString();
        }
#endif

        public override string ToString() => Label.ToString();
    }
}
