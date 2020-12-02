using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    public class File : LabelledEntity, IFileOrFolder
    {
        protected string OriginalPath { get; }
        protected PathTransformer.ITransformedPath TransformedPath { get; }

        public File(Context cx, string path) : base(cx)
        {
            this.OriginalPath = path;
            TransformedPath = cx.Cx.Extractor.PathTransformer.Transform(OriginalPath);
        }

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.Write(TransformedPath.DatabaseId);
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
                    var parent = Cx.CreateFolder(dir);
                    yield return parent;
                    yield return Tuples.containerparent(parent, this);
                }
                yield return Tuples.files(this, TransformedPath.Value, TransformedPath.NameWithoutExtension, TransformedPath.Extension);
            }
        }

        public override string IdSuffix => ";sourcefile";
    }
}
