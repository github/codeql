using System.IO;

namespace Semmle.Extraction.Entities
{
    internal sealed class Folder : CachedEntity<PathTransformer.ITransformedPath>
    {
        private Folder(Context cx, PathTransformer.ITransformedPath init) : base(cx, init) { }

        public override void Populate(TextWriter trapFile)
        {
            trapFile.folders(this, symbol.Value, symbol.NameWithoutExtension);
            if (symbol.ParentDirectory is PathTransformer.ITransformedPath parent)
                trapFile.containerparent(Create(Context, parent), this);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(System.IO.TextWriter trapFile)
        {
            trapFile.Write(symbol.DatabaseId);
            trapFile.Write(";folder");
        }

        public static Folder Create(Context cx, PathTransformer.ITransformedPath folder) =>
            FolderFactory.Instance.CreateEntity(cx, folder, folder);

        public override Microsoft.CodeAnalysis.Location? ReportingLocation => null;

        private class FolderFactory : ICachedEntityFactory<PathTransformer.ITransformedPath, Folder>
        {
            public static FolderFactory Instance { get; } = new FolderFactory();

            public Folder Create(Context cx, PathTransformer.ITransformedPath init) => new Folder(cx, init);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;

        public override int GetHashCode() => symbol.GetHashCode();

        public override bool Equals(object? obj)
        {
            return obj is Folder folder && Equals(folder.symbol, symbol);
        }
    }
}
