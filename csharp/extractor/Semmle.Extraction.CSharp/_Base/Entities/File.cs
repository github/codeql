using System;

namespace Semmle.Extraction.Entities
{
    public abstract class File : CachedEntity<string>
    {
        protected File(Context cx, string path)
            : base(cx, path)
        {
            originalPath = path;
            var adjustedPath = BinaryLogExtractionContext.GetAdjustedPath(Context.ExtractionContext, originalPath) ?? path;
            transformedPathLazy = new Lazy<PathTransformer.ITransformedPath>(() => Context.ExtractionContext.PathTransformer.Transform(adjustedPath));
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
