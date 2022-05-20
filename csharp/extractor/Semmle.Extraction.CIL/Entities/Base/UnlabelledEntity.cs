using System;
using System.Collections.Generic;

namespace Semmle.Extraction.CIL
{
    /// <summary>
    /// An entity that has contents to extract. There is no need to populate
    /// a key as it's done in the contructor.
    /// </summary>
    internal abstract class UnlabelledEntity : Extraction.UnlabelledEntity, IExtractedEntity
    {
        public override Context Context => (Context)base.Context;

        protected UnlabelledEntity(Context cx) : base(cx)
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => throw new NotImplementedException();

        public void Extract(Context cx2)
        {
            cx2.Extract(this);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;

        public abstract IEnumerable<IExtractionProduct> Contents { get; }
    }
}
