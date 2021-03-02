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
        // todo: with .NET 5 this can override the base context, and change the return type.
        public Context Cx => (Context)base.Context;

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
            using var writer = new StringWriter();
            WriteQuotedId(writer);
            return writer.ToString();
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;

        public abstract IEnumerable<IExtractionProduct> Contents { get; }
    }
}
