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

        public Label Label { get; set; }

        public abstract void WriteId(TextWriter trapFile);

        public abstract void WriteQuotedId(TextWriter trapFile);

        public abstract Location? ReportingLocation { get; }

        public abstract TrapStackBehaviour TrapStackBehaviour { get; }

        public void DefineLabel(TextWriter trapFile, Extractor extractor)
        {
            trapFile.WriteLabel(this);
            trapFile.Write("=");
            try
            {
                WriteQuotedId(trapFile);
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

#if DEBUG_LABELS
        /// <summary>
        /// Generates a debug string for this entity.
        /// </summary>
        public string GetDebugLabel()
        {
            using var writer = new StringWriter();
            writer.WriteLabel(Label.Value);
            writer.Write('=');
            WriteQuotedId(writer);
            return writer.ToString();
        }
#endif

        public override string ToString() => Label.ToString();
    }
}
