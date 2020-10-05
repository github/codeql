using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    internal interface IFileOrFolder : IEntity
    {
    }

    internal interface IFile : IFileOrFolder
    {
    }

    public class File : LabelledEntity, IFile
    {
        protected string OriginalPath { get; }
        protected PathTransformer.ITransformedPath TransformedPath { get; }

        public File(Context cx, string path) : base(cx)
        {
            this.OriginalPath = path;
            TransformedPath = cx.Cx.Extractor.PathTransformer.Transform(OriginalPath);
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
                    var parent = Cx.CreateFolder(dir);
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
        private readonly PDB.ISourceFile file;

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
                    Cx.Cx.Extractor.Logger.Log(Util.Logging.Severity.Warning, string.Format("PDB source file {0} could not be found", OriginalPath));
                else
                    Cx.Cx.TrapWriter.Archive(TransformedPath, text);

                yield return Tuples.file_extraction_mode(this, 2);
            }
        }
    }
}
