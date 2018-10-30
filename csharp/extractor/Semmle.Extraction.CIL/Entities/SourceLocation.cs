using System.Collections.Generic;
using Semmle.Extraction.PDB;

namespace Semmle.Extraction.CIL.Entities
{
    public interface ISourceLocation : ILocation
    {
    }

    public sealed class PdbSourceLocation : LabelledEntity, ISourceLocation
    {
        readonly Location location;
        readonly PdbSourceFile file;

        public PdbSourceLocation(Context cx, PDB.Location location) : base(cx)
        {
            this.location = location;
            file = cx.CreateSourceFile(location.File);

            ShortId = file.ShortId + separator + new IntId(location.StartLine) + separator + new IntId(location.StartColumn) + separator + new IntId(location.EndLine) + separator + new IntId(location.EndColumn);
        }

        static readonly Id suffix = new StringId(";sourcelocation");
        static readonly Id separator = new StringId(",");

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return file;
                yield return Tuples.locations_default(this, file, location.StartLine, location.StartColumn, location.EndLine, location.EndColumn);
            }
        }

        public override Id IdSuffix => suffix;
    }
}
