using System;
using System.Collections.Generic;

namespace Semmle.Extraction.PowerShell.Entities
{
    /// <summary>
    /// An entity that has contents to extract. There is no need to populate
    /// a key as it's done in the contructor.
    /// </summary>
    internal abstract class UnlabelledEntity : Extraction.UnlabelledEntity, IExtractedEntity
    {
        public PowerShellContext PowerShellContext => (PowerShellContext)base.Context;

        protected UnlabelledEntity(PowerShellContext cx) : base(cx)
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => throw new NotImplementedException();

        public void Extract(PowerShellContext cx2)
        {
            cx2.Extract(this);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;

        public abstract IEnumerable<IExtractionProduct> Contents { get; }
    }
}
