using System;
using System.IO;

namespace Semmle.Extraction.Entities
{
    internal sealed class GeneratedFile : File
    {
        private GeneratedFile(Context cx) : base(cx, "") { }

        public override bool NeedsPopulation => true;

        public sealed override void PopulateShared(Action<Action<TextWriter>> withTrapFile)
        {
            withTrapFile(trapFile => trapFile.files(this, ""));
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
