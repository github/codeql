using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    internal sealed class Folder : LabelledEntity, IFileOrFolder
    {
        private readonly PathTransformer.ITransformedPath transformedPath;

        public Folder(Context cx, PathTransformer.ITransformedPath path) : base(cx)
        {
            this.transformedPath = path;
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.Write(transformedPath.DatabaseId);
            trapFile.Write(";folder");
        }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                if (transformedPath.ParentDirectory is PathTransformer.ITransformedPath parent)
                {
                    var parentFolder = Context.CreateFolder(parent);
                    yield return parentFolder;
                    yield return Tuples.containerparent(parentFolder, this);
                }
                yield return Tuples.folders(this, transformedPath.Value);
            }
        }

        public override bool Equals(object? obj)
        {
            return obj is Folder folder && transformedPath == folder.transformedPath;
        }

        public override int GetHashCode() => transformedPath.GetHashCode();
    }
}
