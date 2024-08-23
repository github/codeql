using Microsoft.CodeAnalysis;
using System.IO;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class SourceCodeLocation : Extraction.Entities.SourceLocation
    {
        public PowerShellContext powershellContext => (PowerShellContext)base.Context;

        protected SourceCodeLocation(PowerShellContext cx, Location init)
            : base(cx, init)
        {
            Position = init.GetLineSpan();
            FileEntity = File.Create(powershellContext, Position.Path);
        }

        public override bool NeedsPopulation { get; } = true;

        public static SourceCodeLocation Create(PowerShellContext cx, Location loc) => SourceLocationFactory.Instance.CreateEntity(cx, loc, loc);

        public override void Populate(TextWriter trapFile)
        {
            trapFile.locations_default(this, FileEntity,
                Position.Span.Start.Line, Position.Span.Start.Character,
                Position.Span.End.Line, Position.Span.End.Character);
        }

        public FileLinePositionSpan Position
        {
            get;
        }

        public File FileEntity
        {
            get;
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.Write("loc,");
            trapFile.WriteSubId(FileEntity);
            trapFile.Write(',');
            trapFile.Write(Position.Span.Start.Line);
            trapFile.Write(',');
            trapFile.Write(Position.Span.Start.Character);
            trapFile.Write(',');
            trapFile.Write(Position.Span.End.Line);
            trapFile.Write(',');
            trapFile.Write(Position.Span.End.Character);
        }

        private class SourceLocationFactory : CachedEntityFactory<Location, SourceCodeLocation>
        {
            public static SourceLocationFactory Instance { get; } = new SourceLocationFactory();

            public override SourceCodeLocation Create(PowerShellContext cx, Location init) => new SourceCodeLocation(cx, init);
        }
    }
}
