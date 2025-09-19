using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    public class GeneratedLocation : SourceLocation
    {
        protected File GenFile { get; init; }

        protected GeneratedLocation(Context cx)
            : base(cx, null)
        {
            GenFile = GeneratedFile.Create(cx);
        }

        public override void Populate(TextWriter trapFile)
        {
            trapFile.locations_default(this, GenFile, 0, 0, 0, 0);
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            if (Context.ExtractionContext.IsStandalone)
            {
                WriteStarId(trapFile);
                return;
            }

            trapFile.Write("loc,");
            trapFile.WriteSubId(GenFile);
            trapFile.Write(",0,0,0,0");
        }

        public override int GetHashCode() => 98732567;

        public override bool Equals(object? obj) => obj is not null && obj.GetType() == typeof(GeneratedLocation);

        public static GeneratedLocation Create(Context cx) => GeneratedLocationFactory.Instance.CreateEntity(cx, typeof(GeneratedLocation), null);

        private class GeneratedLocationFactory : CachedEntityFactory<string?, GeneratedLocation>
        {
            public static GeneratedLocationFactory Instance { get; } = new GeneratedLocationFactory();

            public override GeneratedLocation Create(Context cx, string? init) => new GeneratedLocation(cx);
        }
    }
}
