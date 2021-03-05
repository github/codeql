using System;
using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.Entities
{
    public abstract class SourceLocation : Location
    {
        protected SourceLocation(Context cx, Microsoft.CodeAnalysis.Location? init) : base(cx, init)
        {
        }

        public override bool NeedsPopulation => true;
    }

    public class NonGeneratedSourceLocation : SourceLocation
    {
        protected NonGeneratedSourceLocation(Context cx, Microsoft.CodeAnalysis.Location init)
            : base(cx, init)
        {
            Position = init.GetLineSpan();
            FileEntity = File.Create(base.Context, Position.Path);
        }

        public static Location Create(Context cx, Microsoft.CodeAnalysis.Location loc) => SourceLocationFactory.Instance.CreateEntity(cx, loc, loc);

        public override void Populate(TextWriter trapFile)
        {
            trapFile.locations_default(this, FileEntity,
                Position.Span.Start.Line + 1, Position.Span.Start.Character + 1,
                Position.Span.End.Line + 1, Position.Span.End.Character);

            var mapped = Symbol!.GetMappedLineSpan();
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

        private class SourceLocationFactory : ICachedEntityFactory<Microsoft.CodeAnalysis.Location, SourceLocation>
        {
            public static SourceLocationFactory Instance { get; } = new SourceLocationFactory();

            public SourceLocation Create(Context cx, Microsoft.CodeAnalysis.Location init) => new NonGeneratedSourceLocation(cx, init);
        }
    }
}
