using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.Entities
{
    public class SourceLocation : Location
    {
        protected SourceLocation(Context cx, Microsoft.CodeAnalysis.Location init)
            : base(cx, init) { }

        public new static Location Create(Context cx, Microsoft.CodeAnalysis.Location loc) => SourceLocationFactory.Instance.CreateEntity(cx, loc);

        public override void Populate()
        {
            Position = symbol.GetLineSpan();
            FileEntity = File.Create(Context, Position.Path);
            Context.TrapWriter.locations_default(this, FileEntity, Position.Span.Start.Line + 1, Position.Span.Start.Character + 1,
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

        public override IId Id
        {
            get
            {
                FileLinePositionSpan l = symbol.GetLineSpan();
                FileEntity = Entities.File.Create(Context, l.Path);
                return new Key("loc,", FileEntity, ",", l.Span.Start.Line + 1, ",",
                    l.Span.Start.Character + 1, ",", l.Span.End.Line + 1, ",", l.Span.End.Character);
            }
        }

        class SourceLocationFactory : ICachedEntityFactory<Microsoft.CodeAnalysis.Location, SourceLocation>
        {
            public static readonly SourceLocationFactory Instance = new SourceLocationFactory();

            public SourceLocation Create(Context cx, Microsoft.CodeAnalysis.Location init) => new SourceLocation(cx, init);
        }
    }
}
