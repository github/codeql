using System.Collections.Generic;
using System.Linq;
using System.IO;
using System;

namespace Semmle.BuildAnalyser
{
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
        /// <param name="dirs">Directories to search.</param>
        /// <param name="progress">Callback for progress.</param>
        public AssemblyCache(IEnumerable<string> dirs, IProgressMonitor progress)
        {
            foreach (var dir in dirs)
            {
                progress.FindingFiles(dir);
                AddReferenceDirectory(dir);
            }
            IndexReferences();
        }

        /// <summary>
        /// Finds all assemblies nested within a directory
        /// and adds them to its index.
        /// (Indexing is performed at a later stage by IndexReferences()).
        /// </summary>
        /// <param name="dir">The directory to index.</param>
        private void AddReferenceDirectory(string dir)
        {
            foreach (var dll in new DirectoryInfo(dir).EnumerateFiles("*.dll", SearchOption.AllDirectories))
            {
                pendingDllsToIndex.Enqueue(dll.FullName);
            }
        }

        /// <summary>
        /// Indexes all DLLs we have located.
        /// Because this is a potentially time-consuming operation, it is put into a separate stage.
        /// </summary>
        private void IndexReferences()
        {
            // Read all of the files
            foreach (var filename in pendingDllsToIndex)
            {
                IndexReference(filename);
            }

            // Index "assemblyInfo" by version string
            // The OrderBy is used to ensure that we by default select the highest version number.
            foreach (var info in assemblyInfoByFileName.Values.OrderBy(info => info.Id))
            {
                foreach (var index in info.IndexStrings)
                    assemblyInfoById[index] = info;
            }
        }

        private void IndexReference(string filename)
        {
            try
            {
                var info = AssemblyInfo.ReadFromFile(filename);
                assemblyInfoByFileName[filename] = info;
            }
            catch (AssemblyLoadException)
            {
                failedAssemblyInfoFileNames.Add(filename);
            }
        }

        /// <summary>
        /// The number of DLLs which are assemblies.
        /// </summary>
        public int AssemblyCount => assemblyInfoByFileName.Count;

        /// <summary>
        /// The number of DLLs which weren't assemblies. (E.g. C++).
        /// </summary>
        public int NonAssemblyCount => failedAssemblyInfoFileNames.Count;

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

            string assemblyName;
            (id, assemblyName) = AssemblyInfo.ComputeSanitizedAssemblyInfo(id);

            // Look up the id in our references map.
            if (assemblyInfoById.TryGetValue(id, out var result))
            {
                // The string is in the references map.
                return result;
            }

            // Attempt to load the reference from the GAC.
            try
            {
                var loadedAssembly = System.Reflection.Assembly.ReflectionOnlyLoad(id);

                if (loadedAssembly != null)
                {
                    // The assembly was somewhere we haven't indexed before.
                    // Add this assembly to our index so that subsequent lookups are faster.

                    result = AssemblyInfo.MakeFromAssembly(loadedAssembly);
                    assemblyInfoById[id] = result;
                    assemblyInfoByFileName[loadedAssembly.Location] = result;
                    return result;
                }
            }
            catch (FileNotFoundException)
            {
                // A suitable assembly could not be found
            }
            catch (FileLoadException)
            {
                // The assembly cannot be loaded for some reason
                // e.g. The name is malformed.
            }
            catch (PlatformNotSupportedException)
            {
                // .NET Core does not have a GAC.
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

        private readonly Queue<string> pendingDllsToIndex = new Queue<string>();

        private readonly Dictionary<string, AssemblyInfo> assemblyInfoByFileName = new Dictionary<string, AssemblyInfo>();

        // List of DLLs which are not assemblies.
        // We probably don't need to keep this
        private readonly List<string> failedAssemblyInfoFileNames = new List<string>();

        // Map from assembly id (in various formats) to the full info.
        private readonly Dictionary<string, AssemblyInfo> assemblyInfoById = new Dictionary<string, AssemblyInfo>();

        private readonly HashSet<string> failedAssemblyInfoIds = new HashSet<string>();
    }
}
