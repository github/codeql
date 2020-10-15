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
        protected readonly string OriginalPath;
        protected readonly PathTransformer.ITransformedPath TransformedPath;

        public File(Context cx, string path) : base(cx)
        {
            this.OriginalPath = path;
            TransformedPath = cx.cx.Extractor.PathTransformer.Transform(OriginalPath);
        }

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.Write(TransformedPath.DatabaseId);
        }

        public override bool Equals(object? obj)
        {
            return GetType() == obj?.GetType() && OriginalPath == ((File)obj).OriginalPath;
        }

        public override int GetHashCode() => 11 * OriginalPath.GetHashCode();

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                if (TransformedPath.ParentDirectory is PathTransformer.ITransformedPath dir)
                {
                    var parent = cx.CreateFolder(dir);
                    yield return parent;
                    yield return Tuples.containerparent(parent, this);
                }
                yield return Tuples.files(this, TransformedPath.Value, TransformedPath.NameWithoutExtension, TransformedPath.Extension);
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
                    cx.cx.Extractor.Logger.Log(Util.Logging.Severity.Warning, string.Format("PDB source file {0} could not be found", OriginalPath));
                else
                    cx.cx.TrapWriter.Archive(TransformedPath, text);

                yield return Tuples.file_extraction_mode(this, 2);
            }
        }
    }
}
