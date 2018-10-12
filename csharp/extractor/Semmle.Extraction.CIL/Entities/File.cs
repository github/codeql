using System.Collections.Generic;

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
        protected readonly string path;

        public File(Context cx, string path) : base(cx)
        {
            this.path = path.Replace("\\", "/");
            ShortId = new StringId(path.Replace(":", "_"));
        }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                var parent = cx.CreateFolder(System.IO.Path.GetDirectoryName(path));
                yield return parent;
                yield return Tuples.containerparent(parent, this);
                yield return Tuples.files(this, path, System.IO.Path.GetFileNameWithoutExtension(path), System.IO.Path.GetExtension(path).Substring(1));
            }
        }

        public override Id IdSuffix => suffix;

        static readonly Id suffix = new StringId(";sourcefile");
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
