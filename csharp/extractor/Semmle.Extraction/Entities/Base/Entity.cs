using Microsoft.CodeAnalysis;
using System;
using System.IO;

namespace Semmle.Extraction
{
    public abstract class EntityBase : IEntity
    {
        public Label Label { get; set; }

        public abstract void WriteId(EscapingTextWriter trapFile);

        public virtual void WriteQuotedId(EscapingTextWriter trapFile)
        {
            trapFile.WriteUnescaped("@\"");
            WriteId(trapFile);
            trapFile.WriteUnescaped('\"');
        }

        public virtual void DefineLabel(TextWriter trapFile, Extractor extractor)
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
    }

    public abstract class Entity : EntityBase
    {
        public virtual Context Context { get; }

        protected Entity(Context context)
        {
            this.Context = context;
        }

        public void DefineFreshLabel(TextWriter trapFile)
        {
            trapFile.WriteLabel(this);
            trapFile.WriteLine("=*");
        }

        /// <summary>
        /// The location for reporting purposes.
        /// </summary>
        public abstract Location? ReportingLocation { get; }

        /// <summary>
        /// How the entity handles .push and .pop.
        /// </summary>
        public abstract TrapStackBehaviour TrapStackBehaviour { get; }

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

    /// <summary>
    /// An entity that is shared across a compilation, and which will
    /// be put into a dedicated, shared TRAP file.
    ///
    /// Unlike the `Entity` class, this class does delibarately not
    /// contain a reference to a context, which allows for contexts to
    /// be garbage collected. Instead, a shared context object is provided
    /// via the population methods below.
    ///
    /// Shared entities are populated after all other entities have been
    /// populated, and duplicate entities are discarded based on `GetHashCode`
    /// and `Equals`.
    /// </summary>
    public abstract class EntityShared : EntityBase
    {
        /// <summary>
        /// Define the label of this entity for use in the shared TRAP file.
        ///
        /// Unlike `DefineLabel`, this method is invoked when populating the shared
        /// TRAP file.
        ///
        /// Since the TRAP file is shared, we cannot access it directly, but instead
        /// via `cx.WithTrapFile`, which ensures appropriate locking.
        /// </summary>
        public void DefineLabelShared(ContextShared cx)
        {
            cx.WithTrapFile(trapFile => base.DefineLabel(trapFile, cx.Extractor));
        }

        /// <summary>
        /// Populate this entity in the shared TRAP file.
        ///
        /// Unlike `Populate`, this method is invoked when populating the shared
        /// TRAP file.
        ///
        /// Since the TRAP file is shared, we cannot access it directly, but instead
        /// via `cx.WithTrapFile`, which ensures appropriate locking.
        /// </summary>
        public abstract void PopulateShared(ContextShared cx);
    }
}
