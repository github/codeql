using System;
using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL
{
    /// <summary>
    /// An entity that needs to be populated during extraction.
    /// This assigns a key and optionally extracts its contents.
    /// </summary>
    internal abstract class LabelledEntity : Extraction.LabelledEntity, IExtractedEntity
    {
        public override Context Context => (Context)base.Context;

        protected LabelledEntity(Context cx) : base(cx)
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => throw new NotImplementedException();

        public void Extract(Context cx2)
        {
            cx2.Populate(this);
        }

        public override string ToString()
        {
            using var writer = new EscapingTextWriter();
            WriteQuotedId(writer);
            return writer.ToString();
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;

        public abstract IEnumerable<IExtractionProduct> Contents { get; }
    }
}
