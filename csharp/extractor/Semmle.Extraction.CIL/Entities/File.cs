using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    interface IFileOrFolder : IEntity
    {
    }

    interface IFile : IFileOrFolder
    {
    }

    public class File : LabelledEntity, IFile
    {
        protected string Path { get; }

        public File(Context cx, string path) : base(cx)
        {
            this.Path = Semmle.Extraction.Entities.File.PathAsDatabaseString(path);
        }

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.Write(Semmle.Extraction.Entities.File.PathAsDatabaseId(Path));
        }

        public override bool Equals(object? obj)
        {
            return GetType() == obj?.GetType() && Path == ((File)obj).Path;
        }

        public override int GetHashCode() => 11 * Path.GetHashCode();

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                var directoryName = System.IO.Path.GetDirectoryName(Path);
                if (directoryName is null)
                    throw new InternalError($"Directory name for path '{Path}' is null.");

                var parent = Cx.CreateFolder(directoryName);
                yield return parent;
                yield return Tuples.containerparent(parent, this);
                yield return Tuples.files(this, Path, System.IO.Path.GetFileNameWithoutExtension(Path), System.IO.Path.GetExtension(Path).Substring(1));
            }
        }

        public override string IdSuffix => ";sourcefile";
    }

    public class PdbSourceFile : File
    {
        readonly PDB.ISourceFile file;

        public PdbSourceFile(Context cx, PDB.ISourceFile file) : base(cx, file.Path)
        {
            this.file = file;
        }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                foreach (var c in base.Contents)
                    yield return c;

                var text = file.Contents;

                if (text == null)
                    Cx.Cx.Extractor.Logger.Log(Util.Logging.Severity.Warning, string.Format("PDB source file {0} could not be found", Path));
                else
                    Cx.Cx.TrapWriter.Archive(Path, text);

                yield return Tuples.file_extraction_mode(this, 2);
            }
        }
    }
}
