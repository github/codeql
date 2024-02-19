using System;
using System.IO;
using Microsoft.CodeAnalysis;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class NonGeneratedSourceLocation : Extraction.Entities.SourceLocation
    {
        public override Context Context => (Context)base.Context;

        protected NonGeneratedSourceLocation(Context cx, Location init)
            : base(cx, init)
        {
            Position = init.GetLineSpan();
            FileEntity = File.Create(Context, Position.Path);
        }

        public static NonGeneratedSourceLocation Create(Context cx, Location loc) => SourceLocationFactory.Instance.CreateEntity(cx, loc, loc);

        public override void Populate(TextWriter trapFile)
        {
            trapFile.locations_default(this, FileEntity,
                Position.Span.Start.Line + 1, Position.Span.Start.Character + 1,
                Position.Span.End.Line + 1, Position.Span.End.Character);

            var mapped = Symbol.GetMappedLineSpan();
            if (mapped.HasMappedPath && mapped.IsValid)
            {
                var path = TryAdjustRelativeMappedFilePath(mapped.Path, Position.Path, Context.Extractor.Logger);
                var mappedLoc = Create(Context, Location.Create(path, default, mapped.Span));

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

        public override void WriteId(EscapingTextWriter trapFile)
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

        private class SourceLocationFactory : CachedEntityFactory<Location, NonGeneratedSourceLocation>
        {
            public static SourceLocationFactory Instance { get; } = new SourceLocationFactory();

            public override NonGeneratedSourceLocation Create(Context cx, Location init) => new NonGeneratedSourceLocation(cx, init);
        }

        public static string TryAdjustRelativeMappedFilePath(string mappedToPath, string mappedFromPath, ILogger logger)
        {
            if (!Path.IsPathRooted(mappedToPath))
            {
                try
                {
                    var fullPath = Path.GetFullPath(Path.Combine(Path.GetDirectoryName(mappedFromPath)!, mappedToPath));
                    logger.LogDebug($"Found relative path in line mapping: '{mappedToPath}', interpreting it as '{fullPath}'");

                    mappedToPath = fullPath;
                }
                catch (Exception e)
                {
                    logger.LogDebug($"Failed to compute absolute path for relative path in line mapping: '{mappedToPath}': {e}");
                }
            }

            return mappedToPath;
        }
    }
}
