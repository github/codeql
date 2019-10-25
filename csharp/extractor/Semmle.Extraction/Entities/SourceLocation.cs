using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.Entities
{
    public class SourceLocation : Location
    {
        protected SourceLocation(Context cx, Microsoft.CodeAnalysis.Location init)
            : base(cx, init) { }

        public new static Location Create(Context cx, Microsoft.CodeAnalysis.Location loc) => SourceLocationFactory.Instance.CreateEntity(cx, loc);

        public override void Populate(TextWriter trapFile)
        {
            Position = symbol.GetLineSpan();
            FileEntity = File.Create(Context, Position.Path);
            trapFile.locations_default(this, FileEntity, Position.Span.Start.Line + 1, Position.Span.Start.Character + 1,
                    Position.Span.End.Line + 1, Position.Span.End.Character);
        }

        public override bool NeedsPopulation => true;

        public FileLinePositionSpan Position
        {
            get;
            private set;
        }

        public File FileEntity
        {
            get;
            private set;
        }

        public override void WriteId(System.IO.TextWriter trapFile)
        {
            FileLinePositionSpan l = symbol.GetLineSpan();
            FileEntity = Entities.File.Create(Context, l.Path);
            trapFile.Write("loc,");
            trapFile.WriteSubId(FileEntity);
            trapFile.Write(',');
            trapFile.Write(l.Span.Start.Line + 1);
            trapFile.Write(',');
            trapFile.Write(l.Span.Start.Character + 1);
            trapFile.Write(',');
            trapFile.Write(l.Span.End.Line + 1);
            trapFile.Write(',');
            trapFile.Write(l.Span.End.Character);
        }

        class SourceLocationFactory : ICachedEntityFactory<Microsoft.CodeAnalysis.Location, SourceLocation>
        {
            public static readonly SourceLocationFactory Instance = new SourceLocationFactory();

            public SourceLocation Create(Context cx, Microsoft.CodeAnalysis.Location init) => new SourceLocation(cx, init);
        }
    }
}
