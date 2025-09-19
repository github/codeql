using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    /// <summary>
    /// Used to create a single canonical empty location entity.
    /// </summary>
    public class EmptyLocation : GeneratedLocation
    {
        private EmptyLocation(Context cx) : base(cx) { }

        public override void Populate(TextWriter trapFile)
        {
            trapFile.locations_default(this, GenFile, -1, -1, -1, -1);
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
            trapFile.Write(",-1,-1,-1,-1");
        }

        public static new EmptyLocation Create(Context cx) => EmptyLocationFactory.Instance.CreateEntity(cx, typeof(EmptyLocation), null);

        private class EmptyLocationFactory : CachedEntityFactory<string?, EmptyLocation>
        {
            public static EmptyLocationFactory Instance { get; } = new EmptyLocationFactory();

            /// <summary>
            /// The QL library assumes the presence of a single empty location element.
            /// </summary>
            public override EmptyLocation Create(Context cx, string? init) => new EmptyLocation(cx);
        }
    }

}
