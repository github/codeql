using System;
using System.Collections.Generic;

namespace Semmle.Extraction.CIL
{
    /// <summary>
    /// An entity that has contents to extract. There is no need to populate
    /// a key as it's done in the contructor.
    /// </summary>
    public abstract class UnlabelledEntity : Extraction.UnlabelledEntity, IExtractedEntity
    {
        // todo: with .NET 5 this can override the base context, and change the return type.
        public Context Cx { get; }

        protected UnlabelledEntity(Context cx) : base(cx.Cx)
        {
            Cx = cx;
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
