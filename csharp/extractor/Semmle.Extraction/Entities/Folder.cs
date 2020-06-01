using System.IO;

namespace Semmle.Extraction.Entities
{
    sealed class Folder : CachedEntity<DirectoryInfo>
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

        public string DatabasePath => File.PathAsDatabaseId(Path);

        public override void Populate(TextWriter trapFile)
        {
            // Ensure that the name of the root directory is consistent
            // with the XmlTrapWriter.
            // Linux/Windows: java.io.File.getName() returns ""
            // On Linux: System.IO.DirectoryInfo.Name returns "/"
            // On Windows: System.IO.DirectoryInfo.Name returns "L:\"
            string shortName = symbol.Parent == null ? "" : symbol.Name;

            trapFile.folders(this, File.PathAsDatabaseString(Path), shortName);
            if (symbol.Parent != null)
            {
                trapFile.containerparent(Create(Context, symbol.Parent), this);
            }
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(System.IO.TextWriter trapFile)
        {
            trapFile.Write(DatabasePath);
            trapFile.Write(";folder");
        }

        public static Folder Create(Context cx, DirectoryInfo folder) =>
            FolderFactory.Instance.CreateEntity2(cx, folder);

        public override Microsoft.CodeAnalysis.Location? ReportingLocation => null;

        class FolderFactory : ICachedEntityFactory<DirectoryInfo, Folder>
        {
            public static readonly FolderFactory Instance = new FolderFactory();

            public Folder Create(Context cx, DirectoryInfo init) => new Folder(cx, init);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;

        public override int GetHashCode() => Path.GetHashCode();

        public override bool Equals(object? obj)
        {
            return obj is Folder folder && folder.Path == Path;
        }
    }
}
