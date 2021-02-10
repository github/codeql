using System.IO;

namespace Semmle.Extraction.Entities
{
    public class GeneratedLocation : SourceLocation
    {
        private readonly File generatedFile;

        private GeneratedLocation(Context cx)
            : base(cx, null)
        {
            generatedFile = File.CreateGenerated(cx);
        }

        public override void Populate(TextWriter trapFile)
        {
            trapFile.locations_default(this, generatedFile, 0, 0, 0, 0);
        }

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.Write("loc,");
            trapFile.WriteSubId(generatedFile);
            trapFile.Write(",0,0,0,0");
        }

        public override int GetHashCode() => 98732567;

        public override bool Equals(object? obj) => obj != null && obj.GetType() == typeof(GeneratedLocation);

        public static GeneratedLocation Create(Context cx) => GeneratedLocationFactory.Instance.CreateEntity(cx, typeof(GeneratedLocation), null);

        private class GeneratedLocationFactory : ICachedEntityFactory<string?, GeneratedLocation>
        {
            public static GeneratedLocationFactory Instance { get; } = new GeneratedLocationFactory();

            public GeneratedLocation Create(Context cx, string? init) => new GeneratedLocation(cx);
        }
    }
}
