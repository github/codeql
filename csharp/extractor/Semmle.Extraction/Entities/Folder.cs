using System.IO;

namespace Semmle.Extraction.Entities
{
    class Folder : CachedEntity<DirectoryInfo>
    {
        Folder(Context cx, DirectoryInfo init)
            : base(cx, init)
        {
            Path = init.FullName;
        }

        public string Path
        {
            get;
            private set;
        }

        public string DatabasePath => File.FileAsDatabaseString(Path);

        public override void Populate()
        {
            // Ensure that the name of the root directory is consistent
            // with the XmlTrapWriter.
            // Linux/Windows: java.io.File.getName() returns ""
            // On Linux: System.IO.DirectoryInfo.Name returns "/"
            // On Windows: System.IO.DirectoryInfo.Name returns "L:\"
            string shortName = symbol.Parent == null ? "" : symbol.Name;

            Context.Emit(Tuples.folders(this, DatabasePath, shortName));
            if (symbol.Parent != null)
            {
                Context.Emit(Tuples.containerparent(Create(Context, symbol.Parent), this));
            }
        }

        public override bool NeedsPopulation => true;

        public override IId Id => new Key(DatabasePath, ";folder");

        public static Folder Create(Context cx, DirectoryInfo folder) =>
            FolderFactory.Instance.CreateEntity(cx, folder);

        public override Microsoft.CodeAnalysis.Location ReportingLocation => null;

        class FolderFactory : ICachedEntityFactory<DirectoryInfo, Folder>
        {
            public static readonly FolderFactory Instance = new FolderFactory();

            public Folder Create(Context cx, DirectoryInfo init) => new Folder(cx, init);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }
}
