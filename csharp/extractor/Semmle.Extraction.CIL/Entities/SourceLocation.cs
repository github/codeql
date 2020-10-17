using System.Collections.Generic;
using System.IO;
using Semmle.Extraction.PDB;

namespace Semmle.Extraction.CIL.Entities
{
    public interface ISourceLocation : ILocation
    {
    }

    public sealed class PdbSourceLocation : LabelledEntity, ISourceLocation
    {
        private readonly Location location;
        private readonly PdbSourceFile file;

        public PdbSourceLocation(Context cx, PDB.Location location) : base(cx)
        {
            this.location = location;
            file = cx.CreateSourceFile(location.File);
        }

        public override void WriteId(TextWriter trapFile)
        {
            file.WriteId(trapFile);
            trapFile.Write(',');
            trapFile.Write(location.StartLine);
            trapFile.Write(',');
            trapFile.Write(location.StartColumn);
            trapFile.Write(',');
            trapFile.Write(location.EndLine);
            trapFile.Write(',');
            trapFile.Write(location.EndColumn);
        }

        public override bool Equals(object? obj)
        {
            return obj is PdbSourceLocation l && location.Equals(l.location);
        }

        public override int GetHashCode() => location.GetHashCode();

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return file;
                yield return Tuples.locations_default(this, file, location.StartLine, location.StartColumn, location.EndLine, location.EndColumn);
            }
        }

        public override string IdSuffix => ";sourcelocation";
    }
}
