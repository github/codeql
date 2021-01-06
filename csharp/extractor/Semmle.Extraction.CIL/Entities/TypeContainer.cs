using System;
using Microsoft.CodeAnalysis;
using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// Base class for all type containers (namespaces, types, methods).
    /// </summary>
    public abstract class TypeContainer : GenericContext, IExtractedEntity
    {
        protected TypeContainer(Context cx) : base(cx)
        {
        }

        public virtual Label Label { get; set; }

        public abstract void WriteId(TextWriter trapFile);

        public void WriteQuotedId(TextWriter trapFile)
        {
            trapFile.Write("@\"");
            WriteId(trapFile);
            trapFile.Write(IdSuffix);
            trapFile.Write('\"');
        }

        public abstract string IdSuffix { get; }

        Location IEntity.ReportingLocation => throw new NotImplementedException();

        public void Extract(Context cx2) { cx2.Populate(this); }

        public abstract IEnumerable<IExtractionProduct> Contents { get; }

        public override string ToString()
        {
            using var writer = new StringWriter();
            WriteQuotedId(writer);
            return writer.ToString();
        }

        TrapStackBehaviour IEntity.TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }
}
