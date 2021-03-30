using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    interface IFolder : IFileOrFolder
    {
    }

    public sealed class Folder : LabelledEntity, IFolder
    {
        readonly PathTransformer.ITransformedPath TransformedPath;

        public Folder(Context cx, PathTransformer.ITransformedPath path) : base(cx)
        {
            this.TransformedPath = path;
        }

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.Write(TransformedPath.DatabaseId);
        }

        public override string IdSuffix => ";folder";

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                if (TransformedPath.ParentDirectory is PathTransformer.ITransformedPath parent)
                {
                    var parentFolder = cx.CreateFolder(parent);
                    yield return parentFolder;
                    yield return Tuples.containerparent(parentFolder, this);
                }
                yield return Tuples.folders(this, TransformedPath.Value, TransformedPath.NameWithoutExtension);
            }
        }

        public override bool Equals(object obj)
        {
            return obj is Folder folder && TransformedPath == folder.TransformedPath;
        }

        public override int GetHashCode() => TransformedPath.GetHashCode();
    }
}
