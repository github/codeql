using System;
using System.IO;

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

        public override void WriteId(System.IO.TextWriter trapFile)
        {
            trapFile.Write(TransformedPath.DatabaseId);
            trapFile.Write(";sourcefile");
        }

        public static File CreateGenerated(Context cx) => GeneratedFile.Create(cx);

        private class GeneratedFile : File
        {
            private GeneratedFile(Context cx) : base(cx, "") { }

            public override bool NeedsPopulation => true;

            public override void Populate(TextWriter trapFile)
            {
                trapFile.files(this, "", "", "");
            }

            public override void WriteId(TextWriter trapFile)
            {
                trapFile.Write("GENERATED;sourcefile");
            }

            public static GeneratedFile Create(Context cx) =>
                GeneratedFileFactory.Instance.CreateEntity(cx, typeof(GeneratedFile), null);

            private class GeneratedFileFactory : ICachedEntityFactory<string?, GeneratedFile>
            {
                public static GeneratedFileFactory Instance { get; } = new GeneratedFileFactory();

                public GeneratedFile Create(Context cx, string? init) => new GeneratedFile(cx);
            }
        }

        public override Microsoft.CodeAnalysis.Location? ReportingLocation => null;

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }
}
