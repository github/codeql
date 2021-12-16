using System;
using System.IO;

namespace Semmle.Extraction.Entities
{
    public sealed class Folder : CachedEntityShared<PathTransformer.ITransformedPath>
    {
        private Folder(Context cx, PathTransformer.ITransformedPath init) : base(cx, init)
        {
        }

        public override void DefineLabel(TextWriter trapFile, Extractor extractor)
        {
            // Folders are only created as parents of files or other folders, so
            // a label definition is never needed outside of the shared TRAP file
        }

        public sealed override void Populate(TextWriter trapFile)
        {
            Folder? parent = null;

            if (Symbol.ParentDirectory is PathTransformer.ITransformedPath p)
                parent = Create(Context, p);

            // Register the entity for later population in the shared TRAP file
            Context.RegisterSharedEntity(new Shared(Symbol, parent));
        }

        private sealed class Shared : EntityShared
        {
            private PathTransformer.ITransformedPath path;
            private readonly Folder? parent;

            public Shared(PathTransformer.ITransformedPath path, Folder? parent)
            {
                this.path = path;
                this.parent = parent;
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
                obj is Shared s && path.DatabaseId == s.path.DatabaseId;
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.Write(Symbol.DatabaseId);
            trapFile.Write(";folder");
        }

        public static Folder Create(Context cx, PathTransformer.ITransformedPath folder) =>
            FolderFactory.Instance.CreateEntity(cx, folder, folder);

        public override Microsoft.CodeAnalysis.Location? ReportingLocation => null;

        private class FolderFactory : CachedEntityFactory<PathTransformer.ITransformedPath, Folder>
        {
            public static FolderFactory Instance { get; } = new FolderFactory();

            public override Folder Create(Context cx, PathTransformer.ITransformedPath init) => new Folder(cx, init);
        }

        public override int GetHashCode() => Symbol.GetHashCode();

        public override bool Equals(object? obj)
        {
            return obj is Folder folder && Equals(folder.Symbol, Symbol);
        }
    }
}
