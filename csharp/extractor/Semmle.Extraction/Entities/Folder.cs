using System;
using System.IO;

namespace Semmle.Extraction.Entities
{
    public sealed class Folder : EntityShared
    {
        private PathTransformer.ITransformedPath path;
        private readonly Folder? parent;

        public Folder(Context cx, PathTransformer.ITransformedPath path)
        {
            this.path = path;

            if (path.ParentDirectory is PathTransformer.ITransformedPath p)
                parent = new Folder(cx, p);

            cx.RegisterSharedEntity(this);
        }

        public sealed override void PopulateShared(ContextShared cx)
        {
            cx.WithTrapFile(trapFile => trapFile.folders(this, path.Value));
            if (parent is not null)
                cx.WithTrapFile(trapFile => trapFile.containerparent(parent, this));
        }

        public sealed override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.Write(path.DatabaseId);
            trapFile.Write(";folder");
        }

        public sealed override int GetHashCode() => 17 * path.DatabaseId.GetHashCode();

        public sealed override bool Equals(object? obj) =>
            obj is Folder f && path.DatabaseId == f.path.DatabaseId;
    }
}
