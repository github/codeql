using System;
using System.IO;

namespace Semmle.Extraction.Entities
{
    public sealed class Folder : CachedEntityShared<PathTransformer.ITransformedPath>
    {
        private readonly Folder? parent;

        private Folder(Context cx, PathTransformer.ITransformedPath init) : base(cx, init)
        {
            if (Symbol.ParentDirectory is PathTransformer.ITransformedPath p)
                parent = Create(Context, p);
        }

        public override void DefineLabel(TextWriter trapFile, Extractor extractor)
        {
            // Folders are only created as parents of files or other folders, so
            // a label definition is never needed outside of the shared TRAP file
        }

        public sealed override void PopulateShared(Action<Action<TextWriter>> withTrapFile)
        {
            withTrapFile(trapFile => trapFile.folders(this, Symbol.Value));
            if (parent is not null)
                withTrapFile(trapFile => trapFile.containerparent(parent, this));
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
