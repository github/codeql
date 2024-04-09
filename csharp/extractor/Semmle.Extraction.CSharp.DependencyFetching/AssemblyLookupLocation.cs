using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Used to represent a path to an assembly or a directory containing assemblies
    /// and a selector function to determine which files to include, when indexing the assemblies.
    /// </summary>
    internal sealed class AssemblyLookupLocation(string p, Func<string, bool> includeFileName)
    {
        public string Path => p;

        public AssemblyLookupLocation(string p) : this(p, _ => true) { }

        public static implicit operator AssemblyLookupLocation(string path) => new(path);

        /// <summary>
        /// Finds all assemblies nested within the directory `path`
        /// and adds them to the a list of assembly names to index.
        /// Indexing is performed at a later stage. This only collects the names.
        /// </summary>
        /// <param name="dir">The directory to index.</param>
        private void AddReferenceDirectory(List<string> dllsToIndex, ILogger logger)
        {
            var dlls = new DirectoryInfo(p).EnumerateFiles("*.dll", new EnumerationOptions { RecurseSubdirectories = true, MatchCasing = MatchCasing.CaseInsensitive, AttributesToSkip = FileAttributes.None });
            if (!dlls.Any())
            {
                logger.LogWarning($"AssemblyLookupLocation: No DLLs found in the path '{p}'.");
                return;
            }
            foreach (var dll in dlls)
            {
                if (includeFileName(dll.Name))
                {
                    dllsToIndex.Add(dll.FullName);
                }
                else
                {
                    logger.LogInfo($"AssemblyLookupLocation: Skipping {dll.FullName}.");
                }
            }
        }

        /// <summary>
        /// Returns a list of paths to all assemblies in `p` that should be indexed.
        /// </summary>
        /// <param name="logger">Logger</param>
        public List<string> GetDlls(ILogger logger)
        {
            var dllsToIndex = new List<string>();
            if (File.Exists(p))
            {
                if (includeFileName(System.IO.Path.GetFileName(p)))
                {
                    dllsToIndex.Add(p);
                }
                else
                {
                    logger.LogInfo($"AssemblyLookupLocation: Skipping {p}.");
                }
                return dllsToIndex;
            }

            if (Directory.Exists(p))
            {
                logger.LogInfo($"AssemblyLookupLocation: Finding reference DLLs in {p}...");
                AddReferenceDirectory(dllsToIndex, logger);
            }
            else
            {
                logger.LogInfo("AssemblyLookupLocation: Path not found: " + p);
            }
            return dllsToIndex;
        }

        public override bool Equals(object? obj) =>
            obj is AssemblyLookupLocation ap && p.Equals(ap.Path);

        public override int GetHashCode() => p.GetHashCode();

        public override string ToString() => p;
    }
}
