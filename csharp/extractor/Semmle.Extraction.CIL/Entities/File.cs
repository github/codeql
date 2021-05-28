using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    internal class File : LabelledEntity, IFileOrFolder
    {
        protected string OriginalPath { get; }
        protected PathTransformer.ITransformedPath TransformedPath { get; }

        public File(Context cx, string path) : base(cx)
        {
            this.OriginalPath = path;
            TransformedPath = Context.Extractor.PathTransformer.Transform(OriginalPath);
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.Write(TransformedPath.DatabaseId);
            trapFile.Write(";sourcefile");
        }

        public override bool Equals(object? obj)
        {
            return GetType() == obj?.GetType() && OriginalPath == ((File)obj).OriginalPath;
        }

        public override int GetHashCode() => 11 * OriginalPath.GetHashCode();

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                if (TransformedPath.ParentDirectory is PathTransformer.ITransformedPath dir)
                {
                    var parent = Context.CreateFolder(dir);
                    yield return parent;
                    yield return Tuples.containerparent(parent, this);
                }
                yield return Tuples.files(this, TransformedPath.Value, TransformedPath.NameWithoutExtension, TransformedPath.Extension);
            }
        }
    }
}
