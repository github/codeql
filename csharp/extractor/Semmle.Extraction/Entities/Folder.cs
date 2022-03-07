using System.IO;

namespace Semmle.Extraction.Entities
{
    public sealed class Folder : CachedEntity<PathTransformer.ITransformedPath>
    {
        private Folder(Context cx, PathTransformer.ITransformedPath init) : base(cx, init) { }

        public override void Populate(TextWriter trapFile)
        {
            trapFile.folders(this, Symbol.Value);
            if (Symbol.ParentDirectory is PathTransformer.ITransformedPath parent)
                trapFile.containerparent(Create(Context, parent), this);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.Write(Symbol.DatabaseId);
            trapFile.Write(";folder");
        }

        public static Folder Create(Context cx, PathTransformer.ITransformedPath folder) =>
            FolderFactory.Instance.CreateEntity(cx, folder.DatabaseId, folder);

        public override Microsoft.CodeAnalysis.Location? ReportingLocation => null;

        private class FolderFactory : CachedEntityFactory<PathTransformer.ITransformedPath, Folder>
        {
            public static FolderFactory Instance { get; } = new FolderFactory();

            public sealed override bool IsShared(PathTransformer.ITransformedPath folder) => true;

            public override Folder Create(Context cx, PathTransformer.ITransformedPath init) => new Folder(cx, init);
        }
    }
}
