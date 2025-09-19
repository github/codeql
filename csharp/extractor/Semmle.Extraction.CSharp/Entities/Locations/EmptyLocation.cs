using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    /// <summary>
    /// Only used in buildless extraction to ensure that we create a single * empty location.
    /// </summary>
    public class EmptyLocation : SourceLocation
    {
        private readonly File generatedFile;

        private EmptyLocation(Context cx) : base(cx, null)
        {
            generatedFile = GeneratedFile.Create(cx);
        }

        public override void Populate(TextWriter trapFile)
        {
            trapFile.locations_default(this, generatedFile, 0, 0, 0, 0);
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            WriteStarId(trapFile);
        }

        public static EmptyLocation Create(Context cx) => EmptyLocationFactory.Instance.CreateEntity(cx, typeof(GeneratedLocation), null);

        private class EmptyLocationFactory : CachedEntityFactory<string?, EmptyLocation>
        {
            public static EmptyLocationFactory Instance { get; } = new EmptyLocationFactory();

            public override EmptyLocation Create(Context cx, string? init) => new EmptyLocation(cx);
        }
    }

}
