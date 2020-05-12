using Semmle.Util.Logging;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Extraction
{
    /// <summary>
    /// An extractor layout file.
    /// Represents the layout of projects into trap folders and source archives.
    /// </summary>
    public sealed class Layout
    {
        /// <summary>
        /// Exception thrown when the layout file is invalid.
        /// </summary>
        public class InvalidLayoutException : Exception
        {
            public InvalidLayoutException(string file, string message) :
                base("ODASA_CSHARP_LAYOUT " + file + " " + message)
            {
            }
        }

        /// <summary>
        /// List of blocks in the layout file.
        /// </summary>
        readonly List<LayoutBlock> blocks;

        /// <summary>
        /// A subproject in the layout file.
        /// </summary>
        public class SubProject
        {
            /// <summary>
            /// The trap folder, or null for current directory.
            /// </summary>
            public readonly string? TRAP_FOLDER;

            /// <summary>
            /// The source archive, or null to skip.
            /// </summary>
            public readonly string? SOURCE_ARCHIVE;

            public SubProject(string? traps, string? archive)
            {
                TRAP_FOLDER = traps;
                SOURCE_ARCHIVE = archive;
            }

            /// <summary>
            /// Gets the name of the trap file for a given source/assembly file.
            /// </summary>
            /// <param name="srcFile">The source file.</param>
            /// <returns>The full filepath of the trap file.</returns>
            public string GetTrapPath(ILogger logger, string srcFile, TrapWriter.CompressionMode trapCompression) => TrapWriter.TrapPath(logger, TRAP_FOLDER, srcFile, trapCompression);

            /// <summary>
            /// Creates a trap writer for a given source/assembly file.
            /// </summary>
            /// <param name="srcFile">The source file.</param>
            /// <returns>A newly created TrapWriter.</returns>
            public TrapWriter CreateTrapWriter(ILogger logger, string srcFile, bool discardDuplicates, TrapWriter.CompressionMode trapCompression) => 
                new TrapWriter(logger, srcFile, TRAP_FOLDER, SOURCE_ARCHIVE, discardDuplicates, trapCompression);
        }

        readonly SubProject DefaultProject;

        /// <summary>
        /// Finds the suitable directories for a given source file.
        /// Returns null if not included in the layout.
        /// </summary>
        /// <param name="sourceFile">The file to look up.</param>
        /// <returns>The relevant subproject, or null if not found.</returns>
        public SubProject? LookupProjectOrNull(string sourceFile)
        {
            if (!useLayoutFile) return DefaultProject;

            return blocks.
                Where(block => block.Matches(sourceFile)).
                Select(block => block.Directories).
                FirstOrDefault();
        }

        /// <summary>
        /// Finds the suitable directories for a given source file.
        /// Returns the default project if not included in the layout.
        /// </summary>
        /// <param name="sourceFile">The file to look up.</param>
        /// <returns>The relevant subproject, or DefaultProject if not found.</returns>
        public SubProject LookupProjectOrDefault(string sourceFile)
        {
            return LookupProjectOrNull(sourceFile) ?? DefaultProject;
        }

        readonly bool useLayoutFile;

        /// <summary>
        /// Default constructor reads parameters from the environment.
        /// </summary>
        public Layout() : this(
            Environment.GetEnvironmentVariable("CODEQL_EXTRACTOR_CSHARP_TRAP_DIR") ?? Environment.GetEnvironmentVariable("TRAP_FOLDER"),
            Environment.GetEnvironmentVariable("CODEQL_EXTRACTOR_CSHARP_SOURCE_ARCHIVE_DIR") ?? Environment.GetEnvironmentVariable("SOURCE_ARCHIVE"),
            Environment.GetEnvironmentVariable("ODASA_CSHARP_LAYOUT"))
        {
        }

        /// <summary>
        /// Creates the project layout. Reads the layout file if specified.
        /// </summary>
        /// <param name="traps">Directory for trap files, or null to use layout/current directory.</param>
        /// <param name="archive">Directory for source archive, or null for layout/no archive.</param>
        /// <param name="layout">Path of layout file, or null for no layout.</param>
        /// <exception cref="InvalidLayoutException">Failed to read layout file.</exception>
        public Layout(string? traps, string? archive, string? layout)
        {
            useLayoutFile = string.IsNullOrEmpty(traps) && !string.IsNullOrEmpty(layout);
            blocks = new List<LayoutBlock>();

            if (useLayoutFile)
            {
                ReadLayoutFile(layout!);
                DefaultProject = blocks[0].Directories;
            }
            else
            {
                DefaultProject = new SubProject(traps, archive);
            }
        }

        /// <summary>
        /// Is the source file included in the layout?
        /// </summary>
        /// <param name="path">The absolute path of the file to query.</param>
        /// <returns>True iff there is no layout file or the layout file specifies the file.</returns>
        public bool FileInLayout(string path) => LookupProjectOrNull(path) != null;

        void ReadLayoutFile(string layout)
        {
            try
            {
                var lines = File.ReadAllLines(layout);

                int i = 0;
                while (!lines[i].StartsWith("#"))
                    i++;
                while (i < lines.Length)
                {
                    LayoutBlock block = new LayoutBlock(lines, ref i);
                    blocks.Add(block);
                }

                if (blocks.Count == 0)
                    throw new InvalidLayoutException(layout, "contains no blocks");
            }
            catch (IOException ex)
            {
                throw new InvalidLayoutException(layout, ex.Message);
            }
            catch (IndexOutOfRangeException)
            {
                throw new InvalidLayoutException(layout, "is invalid");
            }
        }
    }

    sealed class LayoutBlock
    {
        struct Condition
        {
            private readonly bool include;
            private readonly string prefix;

            public bool Include => include;

            public string Prefix => prefix;

            public Condition(string line)
            {
                include = false;
                if (line.StartsWith("-"))
                    line = line.Substring(1);
                else
                    include = true;
                prefix = Normalise(line.Trim());
            }

            static public string Normalise(string path)
            {
                path = Path.GetFullPath(path);
                return path.Replace('\\', '/');
            }
        }

        private readonly List<Condition> conditions = new List<Condition>();

        public readonly Layout.SubProject Directories;

        string? ReadVariable(string name, string line)
        {
            string prefix = name + "=";
            if (!line.StartsWith(prefix))
                return null;
            return line.Substring(prefix.Length).Trim();
        }

        public LayoutBlock(string[] lines, ref int i)
        {
            // first line: #name
            i++;
            string? TRAP_FOLDER = ReadVariable("TRAP_FOLDER", lines[i++]);
            // Don't care about ODASA_DB.
            ReadVariable("ODASA_DB", lines[i++]);
            string? SOURCE_ARCHIVE = ReadVariable("SOURCE_ARCHIVE", lines[i++]);

            Directories = new Layout.SubProject(TRAP_FOLDER, SOURCE_ARCHIVE);
            // Don't care about ODASA_BUILD_ERROR_DIR.
            ReadVariable("ODASA_BUILD_ERROR_DIR", lines[i++]);
            while (i < lines.Length && !lines[i].StartsWith("#"))
            {
                conditions.Add(new Condition(lines[i++]));
            }
        }

        public bool Matches(string path)
        {
            bool matches = false;
            path = Condition.Normalise(path);
            foreach (Condition condition in conditions)
            {
                if (condition.Include)
                    matches |= path.StartsWith(condition.Prefix);
                else
                    matches &= !path.StartsWith(condition.Prefix);
            }
            return matches;
        }
    }
}
