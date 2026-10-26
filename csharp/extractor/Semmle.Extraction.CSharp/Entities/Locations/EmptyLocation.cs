using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    public class EmptyLocation : SourceLocation
    {
        private readonly File generatedFile;

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
            trapFile.Write("loc,");
            trapFile.WriteSubId(generatedFile);
            trapFile.Write(",0,0,0,0");
        }

        public override int GetHashCode() => 98732567;

        public override bool Equals(object? obj) => obj is not null && obj.GetType() == typeof(EmptyLocation);

        public static EmptyLocation Create(Context cx)
            => EmptyLocationFactory.Instance.CreateEntity(cx, typeof(EmptyLocation), null);

        private class EmptyLocationFactory : CachedEntityFactory<string?, EmptyLocation>
        {
            public static EmptyLocationFactory Instance { get; } = new EmptyLocationFactory();

            public override EmptyLocation Create(Context cx, string? init) => new EmptyLocation(cx);
        }
    }
}
