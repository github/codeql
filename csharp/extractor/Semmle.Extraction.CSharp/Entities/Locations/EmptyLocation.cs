using System.IO;
using System.Threading;

namespace Semmle.Extraction.CSharp.Entities
{
    public class EmptyLocation : SourceLocation
    {
        private readonly File generatedFile;

        // The Ql library assumes the presence of a single "empty" location.
        private static EmptyLocation? instance;
        private static readonly Lock instanceLock = new();

        private EmptyLocation(Context cx)
            : base(cx, null)
        {
            generatedFile = GeneratedFile.Create(cx);
        }

        public override void Populate(TextWriter trapFile)
        {
            trapFile.locations_default(this, generatedFile, 0, 0, 0, 0);
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            if (Context.ExtractionContext.IsStandalone)
            {
                WriteStarId(trapFile);
                return;
            }

            trapFile.Write("loc,");
            trapFile.WriteSubId(generatedFile);
            trapFile.Write(",0,0,0,0");
        }

        public override int GetHashCode() => 98732567;

        public override bool Equals(object? obj) => obj is not null && obj.GetType() == typeof(EmptyLocation);

        public static EmptyLocation Create(Context cx)
        {
            lock (instanceLock)
            {
                instance ??= EmptyLocationFactory.Instance.CreateEntity(cx, typeof(EmptyLocation), null);
                return instance;
            }
        }

        private class EmptyLocationFactory : CachedEntityFactory<string?, EmptyLocation>
        {
            public static EmptyLocationFactory Instance { get; } = new EmptyLocationFactory();

            public override EmptyLocation Create(Context cx, string? init) => new EmptyLocation(cx);
        }
    }
}
