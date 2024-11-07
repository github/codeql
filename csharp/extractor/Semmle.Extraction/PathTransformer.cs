using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.IO;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction
{
    /// <summary>
    /// A class for interpreting path transformers specified using the environment
    /// variable `CODEQL_PATH_TRANSFORMER`.
    /// </summary>
    public sealed class PathTransformer
    {
        public class InvalidPathTransformerException : Exception
        {
            public InvalidPathTransformerException(string message) :
                base($"Invalid path transformer specification: {message}")
            { }
        }

        /// <summary>
        /// A transformed path.
        /// </summary>
        public interface ITransformedPath
        {
            string Value { get; }

            string Extension { get; }

            string NameWithoutExtension { get; }

            ITransformedPath? ParentDirectory { get; }

            ITransformedPath WithSuffix(string suffix);

            string DatabaseId { get; }

            /// <summary>
            /// Gets the name of the trap file for this file.
            /// </summary>
            /// <returns>The full filepath of the trap file.</returns>
            public string GetTrapPath(ILogger logger, TrapWriter.CompressionMode trapCompression) =>
                TrapWriter.TrapPath(logger, Environment.GetEnvironmentVariable("CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"), this, trapCompression);

            /// <summary>
            /// Creates a trap writer for this file.
            /// </summary>
            /// <returns>A newly created TrapWriter.</returns>
            public TrapWriter CreateTrapWriter(ILogger logger, TrapWriter.CompressionMode trapCompression, bool discardDuplicates) =>
                new(logger, this, Environment.GetEnvironmentVariable("CODEQL_EXTRACTOR_CSHARP_TRAP_DIR"), Environment.GetEnvironmentVariable("CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR"), trapCompression, discardDuplicates);
        }

        private struct TransformedPath : ITransformedPath
        {
            public TransformedPath(string value) { this.value = value; }
            private readonly string value;

            public string Value => value;

            public string Extension
            {
                get
                {
                    var extension = Path.GetExtension(value);
                    return string.IsNullOrEmpty(extension) ? "" : extension.Substring(1);
                }
            }

            public string NameWithoutExtension => Path.GetFileNameWithoutExtension(value);

            public ITransformedPath? ParentDirectory
            {
                get
                {
                    var dir = Path.GetDirectoryName(value);
                    if (dir is null)
                        return null;
                    var isWindowsDriveLetter = dir.Length == 2 && char.IsLetter(dir[0]) && dir[1] == ':';
                    if (isWindowsDriveLetter)
                        return null;
                    return new TransformedPath(FileUtils.ConvertToUnix(dir));
                }
            }

            public ITransformedPath WithSuffix(string suffix) => new TransformedPath(value + suffix);

            public string DatabaseId
            {
                get
                {
                    var ret = value;
                    if (ret.Length >= 2 && ret[1] == ':' && Char.IsLower(ret[0]))
                        ret = $"{char.ToUpper(ret[0])}_{ret[2..]}";
                    return ret.Replace('\\', '/').Replace(":", "_");
                }
            }

            public override int GetHashCode() => 11 * value.GetHashCode();

            public override bool Equals(object? obj) => obj is TransformedPath tp && tp.value == value;

            public override string ToString() => value;
        }

        private readonly Func<string, string> transform;

        /// <summary>
        /// Returns the path obtained by transforming `path`.
        /// </summary>
        public ITransformedPath Transform(string path) => new TransformedPath(transform(path));

        /// <summary>
        /// Default constructor reads parameters from the environment.
        /// </summary>
        public PathTransformer(IPathCache pathCache) :
            this(pathCache, Environment.GetEnvironmentVariable("CODEQL_PATH_TRANSFORMER") is string file ? File.ReadAllLines(file) : null)
        {
        }

        /// <summary>
        /// Creates a path transformer based on the specification in `lines`.
        /// Throws `InvalidPathTransformerException` for invalid specifications.
        /// </summary>
        public PathTransformer(IPathCache pathCache, string[]? lines)
        {
            if (lines is null)
            {
                transform = path => FileUtils.ConvertToUnix(pathCache.GetCanonicalPath(path));
                return;
            }

            var sections = ParsePathTransformerSpec(lines);
            transform = path =>
            {
                path = FileUtils.ConvertToUnix(pathCache.GetCanonicalPath(path));
                foreach (var section in sections)
                {
                    if (section.Matches(path, out var transformed))
                        return transformed;
                }
                return path;
            };
        }

        private static IEnumerable<TransformerSection> ParsePathTransformerSpec(string[] lines)
        {
            var sections = new List<TransformerSection>();
            try
            {
                var i = 0;
                while (i < lines.Length && !lines[i].StartsWith("#"))
                    i++;
                while (i < lines.Length)
                {
                    var section = new TransformerSection(lines, ref i);
                    sections.Add(section);
                }

                if (sections.Count == 0)
                    throw new InvalidPathTransformerException("contains no sections.");
            }
            catch (InvalidFilePatternException ex)
            {
                throw new InvalidPathTransformerException(ex.Message);
            }
            return sections;
        }
    }

    internal sealed class TransformerSection
    {
        private readonly string name;
        private readonly List<FilePattern> filePatterns = new List<FilePattern>();

        public TransformerSection(string[] lines, ref int i)
        {
            name = lines[i++].Substring(1); // skip the '#'
            for (; i < lines.Length && !lines[i].StartsWith("#"); i++)
            {
                var line = lines[i];
                if (!string.IsNullOrWhiteSpace(line))
                    filePatterns.Add(new FilePattern(line));
            }
        }

        public bool Matches(string path, [NotNullWhen(true)] out string? transformed)
        {
            if (FilePattern.Matches(filePatterns, path, out var suffix))
            {
                transformed = FileUtils.ConvertToUnix(name) + suffix;
                return true;
            }
            transformed = null;
            return false;
        }
    }
}
