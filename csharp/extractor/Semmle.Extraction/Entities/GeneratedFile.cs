using System;
using System.IO;

namespace Semmle.Extraction.Entities
{
    internal sealed class GeneratedFile : File
    {
        private GeneratedFile(Context cx) : base(cx, "") { }

        public override bool NeedsPopulation => true;

        public override void Populate(TextWriter trapFile)
        {
            // Register the entity for later population in the shared TRAP file
            Context.RegisterSharedEntity(new Shared());
        }

        private sealed class Shared : EntityShared
        {
            public sealed override void PopulateShared(ContextShared cx)
            {
                cx.WithTrapFile(trapFile => trapFile.files(this, ""));
            }

            public override void WriteId(EscapingTextWriter trapFile)
            {
                trapFile.Write("GENERATED;sourcefile");
            }

            public sealed override int GetHashCode() => 1591953;

            public sealed override bool Equals(object? obj) => obj is Shared;
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
