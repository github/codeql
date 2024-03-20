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

    /// <summary>
    /// Manages the set of assemblies.
    /// Searches for assembly DLLs, indexes them and provides
    /// a lookup facility from assembly ID to filename.
    /// </summary>
    internal class AssemblyCache
    {
        /// <summary>
        /// Locate all reference files and index them.
        /// </summary>
        /// <param name="paths">
        /// Paths to search. Directories are searched recursively. Files are added directly to the
        /// assembly cache.
        /// </param>
        /// <param name="logger">Callback for progress.</param>
        public AssemblyCache(IEnumerable<AssemblyPath> paths, IEnumerable<string> frameworkPaths, ILogger logger)
        {
            this.logger = logger;
            foreach (var path in paths)
            {
                path.Process(dllsToIndex, logger);
            }
            IndexReferences(frameworkPaths);
        }

        /// <summary>
        /// Indexes all DLLs we have located.
        /// Because this is a potentially time-consuming operation, it is put into a separate stage.
        /// </summary>
        private void IndexReferences(IEnumerable<string> frameworkPaths)
        {
            logger.LogInfo($"Indexing {dllsToIndex.Count} assemblies...");

            // Read all of the files
            foreach (var filename in dllsToIndex)
            {
                IndexReference(filename);
            }

            logger.LogInfo($"Read {assemblyInfoByFileName.Count} assembly infos");

            foreach (var info in assemblyInfoByFileName.Values
                .OrderBy(info => info.Name)
                .OrderAssemblyInfosByPreference(frameworkPaths))
            {
                foreach (var index in info.IndexStrings)
                {
                    assemblyInfoById[index] = info;
                }
            }
        }

        private void IndexReference(string filename)
        {
            try
            {
                logger.LogDebug($"Reading assembly info from {filename}");
                var info = AssemblyInfo.ReadFromFile(filename);
                assemblyInfoByFileName[filename] = info;
            }
            catch (AssemblyLoadException)
            {
                logger.LogInfo($"Couldn't read assembly info from {filename}");
            }
        }

        /// <summary>
        /// Given an assembly id, determine its full info.
        /// </summary>
        /// <param name="id">The given assembly id.</param>
        /// <returns>The information about the assembly.</returns>
        public AssemblyInfo ResolveReference(string id)
        {
            // Fast path if we've already seen this before.
            if (failedAssemblyInfoIds.Contains(id))
                throw new AssemblyLoadException();

            (id, var assemblyName) = AssemblyInfo.ComputeSanitizedAssemblyInfo(id);

            // Look up the id in our references map.
            if (assemblyInfoById.TryGetValue(id, out var result))
            {
                // The string is in the references map.
                return result;
            }

            // Fallback position - locate the assembly by its lower-case name only.
            var asmName = assemblyName.ToLowerInvariant();

            if (assemblyInfoById.TryGetValue(asmName, out result))
            {
                assemblyInfoById[asmName] = result;  // Speed up the next time the same string is resolved
                return result;
            }

            failedAssemblyInfoIds.Add(id);   // Fail early next time

            throw new AssemblyLoadException();
        }

        /// <summary>
        /// All the assemblies we have indexed.
        /// </summary>
        public IEnumerable<AssemblyInfo> AllAssemblies => assemblyInfoByFileName.Select(a => a.Value);

        /// <summary>
        /// Retrieve the assembly info of a pre-cached assembly.
        /// </summary>
        /// <param name="filepath">The filename to query.</param>
        /// <returns>The assembly info.</returns>
        public AssemblyInfo GetAssemblyInfo(string filepath)
        {
            if (assemblyInfoByFileName.TryGetValue(filepath, out var info))
            {
                return info;
            }

            IndexReference(filepath);

            if (assemblyInfoByFileName.TryGetValue(filepath, out info))
            {
                return info;
            }

            throw new AssemblyLoadException();
        }

        private readonly List<string> dllsToIndex = new List<string>();

        private readonly Dictionary<string, AssemblyInfo> assemblyInfoByFileName = new Dictionary<string, AssemblyInfo>();

        // Map from assembly id (in various formats) to the full info.
        private readonly Dictionary<string, AssemblyInfo> assemblyInfoById = new Dictionary<string, AssemblyInfo>();

        private readonly HashSet<string> failedAssemblyInfoIds = new HashSet<string>();

        private readonly ILogger logger;
    }
}
