using System.Collections.Generic;

namespace Semmle.Extraction.CIL.Entities
{
    internal class PdbSourceFile : File
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

                if (text is null)
                    Context.Extractor.Logger.Log(Util.Logging.Severity.Warning, string.Format("PDB source file {0} could not be found", OriginalPath));
                else
                    Context.TrapWriter.Archive(TransformedPath, text);

                yield return Tuples.file_extraction_mode(this, Context.Extractor.Mode | ExtractorMode.Pdb);
            }
        }
    }
}
