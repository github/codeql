using System;

namespace Semmle.Extraction.Entities
{
    public abstract class File : CachedEntity<string>
    {
        protected File(Context cx, string path)
            : base(cx, path)
        {
            originalPath = path;
            transformedPathLazy = new Lazy<PathTransformer.ITransformedPath>(() => Context.Extractor.PathTransformer.Transform(originalPath));
        }

        protected readonly string originalPath;
        private readonly Lazy<PathTransformer.ITransformedPath> transformedPathLazy;
        protected PathTransformer.ITransformedPath TransformedPath => transformedPathLazy.Value;

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.Write(TransformedPath.DatabaseId);
            trapFile.Write(";sourcefile");
        }

        public override Microsoft.CodeAnalysis.Location? ReportingLocation => null;
    }
}
