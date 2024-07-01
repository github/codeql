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
    internal sealed class AssemblyLookupLocation(string path, Func<string, bool> includeFileName, bool indexSubdirectories = true)
    {
        public string Path => path;

        public AssemblyLookupLocation(string path) : this(path, _ => true) { }

        public static implicit operator AssemblyLookupLocation(string path) => new(path);

        /// <summary>
        /// Finds all assemblies nested within the directory `path`
        /// and adds them to the a list of assembly names to index.
        /// Indexing is performed at a later stage. This only collects the names.
        /// </summary>
        /// <param name="dllsToIndex">List of dlls to index.</param>
        /// <param name="logger">Logger.</param>
        private void AddReferenceDirectory(List<string> dllsToIndex, ILogger logger)
        {
            try
            {
                var dlls = new DirectoryInfo(path).EnumerateFiles("*.dll", new EnumerationOptions { RecurseSubdirectories = indexSubdirectories, MatchCasing = MatchCasing.CaseInsensitive, AttributesToSkip = FileAttributes.None });
                if (!dlls.Any())
                {
                    logger.LogWarning($"AssemblyLookupLocation: No DLLs found in the path '{path}'.");
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
                        logger.LogDebug($"AssemblyLookupLocation: Skipping {dll.FullName}.");
                    }
                }
            }
            catch (Exception e)
            {
                logger.LogError($"AssemblyLookupLocation: Error while searching for DLLs in '{path}': {e.Message}");
            }
        }

        /// <summary>
        /// Returns a list of paths to all assemblies in `path` that should be indexed.
        /// </summary>
        /// <param name="logger">Logger</param>
        public List<string> GetDlls(ILogger logger)
        {
            var dllsToIndex = new List<string>();
            if (File.Exists(path))
            {
                if (includeFileName(System.IO.Path.GetFileName(path)))
                {
                    dllsToIndex.Add(path);
                }
                else
                {
                    logger.LogDebug($"AssemblyLookupLocation: Skipping {path}.");
                }
                return dllsToIndex;
            }

            if (Directory.Exists(path))
            {
                logger.LogDebug($"AssemblyLookupLocation: Finding reference DLLs in {path}...");
                AddReferenceDirectory(dllsToIndex, logger);
            }
            else
            {
                logger.LogDebug($"AssemblyLookupLocation: Path not found: {path}");
            }
            return dllsToIndex;
        }

        public override bool Equals(object? obj) =>
            obj is AssemblyLookupLocation ap && path.Equals(ap.Path);

        public override int GetHashCode() => path.GetHashCode();

        public override string ToString() => path;
    }
}
