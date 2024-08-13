using System;
using System.Collections.Generic;

namespace Semmle.Extraction.PowerShell.Entities
{
    /// <summary>
    /// An entity that needs to be populated during extraction.
    /// This assigns a key and optionally extracts its contents.
    /// </summary>
    internal abstract class LabelledEntity : Extraction.LabelledEntity, IExtractedEntity
    {
        public PowerShellContext PowerShellContext => (PowerShellContext)base.Context;

        protected LabelledEntity(PowerShellContext cx) : base(cx)
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => throw new NotImplementedException();

        public void Extract(PowerShellContext cx2)
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
