using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    internal interface IFolder : IFileOrFolder
    {
    }

    public sealed class Folder : LabelledEntity, IFolder
    {
        private readonly PathTransformer.ITransformedPath transformedPath;

        public Folder(Context cx, PathTransformer.ITransformedPath path) : base(cx)
        {
            this.transformedPath = path;
        }

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.Write(transformedPath.DatabaseId);
        }

        public override string IdSuffix => ";folder";

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                if (transformedPath.ParentDirectory is PathTransformer.ITransformedPath parent)
                {
                    var parentFolder = Cx.CreateFolder(parent);
                    yield return parentFolder;
                    yield return Tuples.containerparent(parentFolder, this);
                }
                yield return Tuples.folders(this, transformedPath.Value, transformedPath.NameWithoutExtension);
            }
        }

        public override bool Equals(object? obj)
        {
            return obj is Folder folder && transformedPath == folder.transformedPath;
        }

        public override int GetHashCode() => transformedPath.GetHashCode();
    }
}
