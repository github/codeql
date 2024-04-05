using System;
using System.Collections.Generic;
using System.IO;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Used to represent a path to an assembly or a directory containing assemblies
    /// and a selector function to determine which files to include, when indexing the assemblies.
    /// </summary>
    internal sealed class AssemblyPath(string p, Func<string, bool> includeFileName)
    {
        public string Path => p;

        public AssemblyPath(string p) : this(p, _ => true) { }

        public static implicit operator AssemblyPath(string path) => new(path);

        /// <summary>
        /// Finds all assemblies nested within the directory `path`
        /// and adds them to the a list of assembly names to index.
        /// Indexing is performed at a later stage. This only collects the names.
        /// </summary>
        /// <param name="dir">The directory to index.</param>
        private void AddReferenceDirectory(List<string> dllsToIndex, ILogger logger)
        {
            foreach (var dll in new DirectoryInfo(p).EnumerateFiles("*.dll", SearchOption.AllDirectories))
            {
                if (includeFileName(dll.Name))
                {
                    dllsToIndex.Add(dll.FullName);
                }
                else
                {
                    logger.LogInfo($"AssemblyPath: Skipping {dll.FullName}.");
                }
            }
        }

        /// <summary>
        /// Finds all assemblies in `p` that should be indexed and adds them to
        /// the list of assembly names to index.
        /// </summary>
        /// <param name="dllsToIndex">List of assembly names to index.</param>
        /// <param name="logger">Logger</param>
        public void Process(List<string> dllsToIndex, ILogger logger)
        {
            if (File.Exists(p))
            {
                if (includeFileName(System.IO.Path.GetFileName(p)))
                {
                    dllsToIndex.Add(p);
                }
                else
                {
                    logger.LogInfo($"AssemblyPath: Skipping {p}.");
                }
                return;
            }

            if (Directory.Exists(p))
            {
                logger.LogInfo($"AssemblyPath: Finding reference DLLs in {p}...");
                AddReferenceDirectory(dllsToIndex, logger);
            }
            else
            {
                logger.LogInfo("AssemblyCache: Path not found: " + p);
            }
        }

        public override bool Equals(object? obj) =>
            obj is AssemblyPath ap && p.Equals(ap.Path);

        public override int GetHashCode() => p.GetHashCode();

        public override string ToString() => p;
    }
}
