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
        protected string path { get; }

        public File(Context cx, string path) : base(cx)
        {
            this.path = Semmle.Extraction.Entities.File.PathAsDatabaseString(path);
        }

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.Write(Semmle.Extraction.Entities.File.PathAsDatabaseId(path));
        }

        public override bool Equals(object? obj)
        {
            return GetType() == obj?.GetType() && path == ((File)obj).path;
        }

        public override int GetHashCode() => 11 * path.GetHashCode();

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                var directoryName = System.IO.Path.GetDirectoryName(path);
                if (directoryName is null)
                    throw new InternalError($"Directory name for path '{path}' is null.");

                var parent = cx.CreateFolder(directoryName);
                yield return parent;
                yield return Tuples.containerparent(parent, this);
                yield return Tuples.files(this, path, System.IO.Path.GetFileNameWithoutExtension(path), System.IO.Path.GetExtension(path).Substring(1));
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
                    cx.cx.Extractor.Logger.Log(Util.Logging.Severity.Warning, string.Format("PDB source file {0} could not be found", path));
                else
                    cx.cx.TrapWriter.Archive(path, text);

                yield return Tuples.file_extraction_mode(this, 2);
            }
        }
    }
}
