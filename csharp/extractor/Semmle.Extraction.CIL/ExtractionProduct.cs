using System;
using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL
{
    /// <summary>
    /// Something that is extracted from an entity.
    /// </summary>
    ///
    /// <remarks>
    /// The extraction algorithm proceeds as follows:
    /// - Construct entity
    /// - Call Extract()
    /// - IExtractedEntity check if already extracted
    /// - Enumerate Contents to produce more extraction products
    /// - Extract these until there is nothing left to extract
    /// </remarks>
    public interface IExtractionProduct
    {
        /// <summary>
        /// Perform further extraction/population of this item as necessary.
        /// </summary>
        ///
        /// <param name="cx">The extraction context.</param>
        void Extract(Context cx);
    }

    /// <summary>
    /// An entity which has been extracted.
    /// </summary>
    public interface IExtractedEntity : IEntity, IExtractionProduct
    {
        /// <summary>
        /// The contents of the entity.
        /// </summary>
        IEnumerable<IExtractionProduct> Contents { get; }
    }

    /// <summary>
    /// An entity that has contents to extract. There is no need to populate
    /// a key as it's done in the contructor.
    /// </summary>
    public abstract class UnlabelledEntity : IExtractedEntity
    {
        public abstract IEnumerable<IExtractionProduct> Contents { get; }
        public Label Label { get; set; }

        public void WriteId(System.IO.TextWriter trapFile)
        {
            trapFile.Write('*');
        }

        public void WriteQuotedId(TextWriter trapFile)
        {
            WriteId(trapFile);
        }

        public Microsoft.CodeAnalysis.Location ReportingLocation => throw new NotImplementedException();

        public virtual void Extract(Context cx2)
        {
            cx2.Extract(this);
        }

        public Context Cx { get; }

        protected UnlabelledEntity(Context cx)
        {
            this.Cx = cx;
            cx.Cx.AddFreshLabel(this);
        }

        TrapStackBehaviour IEntity.TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }

    /// <summary>
    /// An entity that needs to be populated during extraction.
    /// This assigns a key and optionally extracts its contents.
    /// </summary>
    public abstract class LabelledEntity : IExtractedEntity
    {
        public abstract IEnumerable<IExtractionProduct> Contents { get; }
        public Label Label { get; set; }
        public Microsoft.CodeAnalysis.Location ReportingLocation => throw new NotImplementedException();

        public abstract void WriteId(System.IO.TextWriter trapFile);

        public abstract string IdSuffix { get; }

        public void WriteQuotedId(TextWriter trapFile)
        {
            trapFile.Write("@\"");
            WriteId(trapFile);
            trapFile.Write(IdSuffix);
            trapFile.Write('\"');
        }

        public void Extract(Context cx2)
        {
            cx2.Populate(this);
        }

        public Context Cx { get; }

        protected LabelledEntity(Context cx)
        {
            this.Cx = cx;
        }

        public override string ToString()
        {
            using var writer = new StringWriter();
            WriteQuotedId(writer);
            return writer.ToString();
        }

        TrapStackBehaviour IEntity.TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }

    /// <summary>
    /// A tuple that is an extraction product.
    /// </summary>
    internal class Tuple : IExtractionProduct
    {
        private readonly Extraction.Tuple tuple;

        public Tuple(string name, params object[] args)
        {
            tuple = new Extraction.Tuple(name, args);
        }

        public void Extract(Context cx)
        {
            cx.Cx.Emit(tuple);
        }

        public override string ToString() => tuple.ToString();
    }
}
