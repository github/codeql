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
    class AssemblyCache
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
        /// <returns>The number of DLLs within this directory.</returns>
        int AddReferenceDirectory(string dir)
        {
            int count = 0;
            foreach (var dll in new DirectoryInfo(dir).EnumerateFiles("*.dll", SearchOption.AllDirectories))
            {
                dlls.Add(dll.FullName);
                ++count;
            }
            return count;
        }

        /// <summary>
        /// Indexes all DLLs we have located.
        /// Because this is a potentially time-consuming operation, it is put into a separate stage.
        /// </summary>
        void IndexReferences()
        {
            // Read all of the files
            foreach (var filename in dlls)
            {
                var info = AssemblyInfo.ReadFromFile(filename);

                if (info.Valid)
                {
                    assemblyInfo[filename] = info;
                }
                else
                {
                    failedDlls.Add(filename);
                }
            }

            // Index "assemblyInfo" by version string
            // The OrderBy is used to ensure that we by default select the highest version number.
            foreach (var info in assemblyInfo.Values.OrderBy(info => info.Id))
            {
                foreach (var index in info.IndexStrings)
                    references[index] = info;
            }
        }

        /// <summary>
        /// The number of DLLs which are assemblies.
        /// </summary>
        public int AssemblyCount => assemblyInfo.Count;

        /// <summary>
        /// The number of DLLs which weren't assemblies. (E.g. C++).
        /// </summary>
        public int NonAssemblyCount => failedDlls.Count;

        /// <summary>
        /// Given an assembly id, determine its full info.
        /// </summary>
        /// <param name="id">The given assembly id.</param>
        /// <returns>The information about the assembly.</returns>
        public AssemblyInfo ResolveReference(string id)
        {
            // Fast path if we've already seen this before.
            if (failedReferences.Contains(id))
                return AssemblyInfo.Invalid;

            var query = AssemblyInfo.MakeFromId(id);
            id = query.Id;  // Sanitise the id.

            // Look up the id in our references map.
            AssemblyInfo result;
            if (references.TryGetValue(id, out result))
            {
                // The string is in the references map.
                return result;
            }
            else
            {
                // Attempt to load the reference from the GAC.
                try
                {
                    var loadedAssembly = System.Reflection.Assembly.ReflectionOnlyLoad(id);

                    if (loadedAssembly != null)
                    {
                        // The assembly was somewhere we haven't indexed before.
                        // Add this assembly to our index so that subsequent lookups are faster.

                        result = AssemblyInfo.MakeFromAssembly(loadedAssembly);
                        references[id] = result;
                        assemblyInfo[loadedAssembly.Location] = result;
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
                var asmName = query.Name.ToLowerInvariant();

                if (references.TryGetValue(asmName, out result))
                {
                    references[asmName] = result;  // Speed up the next time the same string is resolved
                    return result;
                }

                failedReferences.Add(id);   // Fail early next time

                return AssemblyInfo.Invalid;
            }
        }

        /// <summary>
        /// All the assemblies we have indexed.
        /// </summary>
        public IEnumerable<AssemblyInfo> AllAssemblies => assemblyInfo.Select(a => a.Value);

        /// <summary>
        /// Retrieve the assembly info of a pre-cached assembly.
        /// </summary>
        /// <param name="filepath">The filename to query.</param>
        /// <returns>The assembly info.</returns>
        public AssemblyInfo GetAssemblyInfo(string filepath)
        {
            if(assemblyInfo.TryGetValue(filepath, out var info))
            {
                return info;
            }
            else
            {
                info = AssemblyInfo.ReadFromFile(filepath);
                assemblyInfo.Add(filepath, info);
                return info;
            }
        }

        // List of pending DLLs to index.
        readonly List<string> dlls = new List<string>();

        // Map from filename to assembly info.
        readonly Dictionary<string, AssemblyInfo> assemblyInfo = new Dictionary<string, AssemblyInfo>();

        // List of DLLs which are not assemblies.
        // We probably don't need to keep this
        readonly List<string> failedDlls = new List<string>();

        // Map from assembly id (in various formats) to the full info.
        readonly Dictionary<string, AssemblyInfo> references = new Dictionary<string, AssemblyInfo>();

        // Set of failed assembly ids.
        readonly HashSet<string> failedReferences = new HashSet<string>();
    }
}
