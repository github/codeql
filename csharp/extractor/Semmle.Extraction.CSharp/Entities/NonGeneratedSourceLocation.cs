using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    public class NonGeneratedSourceLocation : Extraction.Entities.SourceLocation
    {
        public override Context Context => (Context)base.Context;

        protected NonGeneratedSourceLocation(Context cx, Microsoft.CodeAnalysis.Location init)
            : base(cx, init)
        {
            Position = init.GetLineSpan();
            FileEntity = File.Create(cx, Position.Path);
        }

        public static Extraction.Entities.SourceLocation Create(Context cx, Microsoft.CodeAnalysis.Location loc) =>
            SourceLocationFactory.Instance.CreateEntity(cx, loc, loc);

        public override void Populate(TextWriter trapFile)
        {
            trapFile.locations_default(this, FileEntity,
                Position.Span.Start.Line + 1, Position.Span.Start.Character + 1,
                Position.Span.End.Line + 1, Position.Span.End.Character);

            var mapped = symbol!.GetMappedLineSpan();
            if (mapped.HasMappedPath && mapped.IsValid)
            {
                var mappedLoc = Create(Context, Microsoft.CodeAnalysis.Location.Create(mapped.Path, default, mapped.Span));

                trapFile.locations_mapped(this, mappedLoc);
            }
        }

        public FileLinePositionSpan Position
        {
            get;
        }

        public File FileEntity
        {
            get;
        }

        public override void WriteId(System.IO.TextWriter trapFile)
        {
            trapFile.Write("loc,");
            trapFile.WriteSubId(FileEntity);
            trapFile.Write(',');
            trapFile.Write(Position.Span.Start.Line + 1);
            trapFile.Write(',');
            trapFile.Write(Position.Span.Start.Character + 1);
            trapFile.Write(',');
            trapFile.Write(Position.Span.End.Line + 1);
            trapFile.Write(',');
            trapFile.Write(Position.Span.End.Character);
        }

        private class SourceLocationFactory : ICachedEntityFactory<Microsoft.CodeAnalysis.Location, Extraction.Entities.SourceLocation>
        {
            public static SourceLocationFactory Instance { get; } = new SourceLocationFactory();

            public Extraction.Entities.SourceLocation Create(Extraction.Context cx, Microsoft.CodeAnalysis.Location init) => new NonGeneratedSourceLocation((Context)cx, init);
        }
    }
}
