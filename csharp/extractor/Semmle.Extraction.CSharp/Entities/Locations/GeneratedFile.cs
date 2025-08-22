using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class GeneratedFile : File
    {
        private GeneratedFile(Context cx) : base(cx, "") { }

        public override bool NeedsPopulation => true;

        public override void Populate(TextWriter trapFile)
        {
            trapFile.files(this, "");
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.Write("GENERATED;sourcefile");
        }

        public static GeneratedFile Create(Context cx) =>
            GeneratedFileFactory.Instance.CreateEntity(cx, typeof(GeneratedFile), null);

        private class GeneratedFileFactory : CachedEntityFactory<string?, GeneratedFile>
        {
            public static GeneratedFileFactory Instance { get; } = new GeneratedFileFactory();

            public override GeneratedFile Create(Context cx, string? init) => new GeneratedFile(cx);
        }
    }
}
