using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Reflection.PortableExecutable;
using System.Reflection.Metadata;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Globalization;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CIL.Driver
{
    /// <summary>
    /// Information about a single assembly.
    /// In particular, provides references between assemblies.
    /// </summary>
    class AssemblyInfo
    {
        public override string ToString() => filename;

        static AssemblyName CreateAssemblyName(MetadataReader mdReader, StringHandle name, System.Version version, StringHandle culture)
        {
            var cultureString = mdReader.GetString(culture);

            var assemblyName = new AssemblyName()
            {
                Name = mdReader.GetString(name),
                Version = version
            };

            if (cultureString != "neutral")
                assemblyName.CultureInfo = CultureInfo.GetCultureInfo(cultureString);

            return assemblyName;
        }

        static AssemblyName CreateAssemblyName(MetadataReader mdReader, AssemblyReference ar)
        {
            var an = CreateAssemblyName(mdReader, ar.Name, ar.Version, ar.Culture);
            if (!ar.PublicKeyOrToken.IsNil)
                an.SetPublicKeyToken(mdReader.GetBlobBytes(ar.PublicKeyOrToken));
            return an;
        }

        static AssemblyName CreateAssemblyName(MetadataReader mdReader, AssemblyDefinition ad)
        {
            var an = CreateAssemblyName(mdReader, ad.Name, ad.Version, ad.Culture);
            if (!ad.PublicKey.IsNil)
                an.SetPublicKey(mdReader.GetBlobBytes(ad.PublicKey));
            return an;
        }

        public AssemblyInfo(string path)
        {
            filename = path;

            // Attempt to open the file and see if it's a valid assembly.
            using (var stream = File.OpenRead(path))
            using (var peReader = new PEReader(stream))
            {
                try
                {
                    if (!peReader.HasMetadata) throw new InvalidAssemblyException();

                    var mdReader = peReader.GetMetadataReader();

                    if (!mdReader.IsAssembly) throw new InvalidAssemblyException();

                    // Get our own assembly name
                    name = CreateAssemblyName(mdReader, mdReader.GetAssemblyDefinition());

                    references = mdReader.AssemblyReferences.
                        Select(r => mdReader.GetAssemblyReference(r)).
                        Select(ar => CreateAssemblyName(mdReader, ar)).
                        ToArray();
                }
                catch (System.BadImageFormatException)
                {
                    // This failed on one of the Roslyn tests that includes
                    // a deliberately malformed assembly.
                    // In this case, we just skip the extraction of this assembly.
                    throw new InvalidAssemblyException();
                }
            }
        }

        public readonly AssemblyName name;
        public readonly string filename;
        public bool extract;
        public readonly AssemblyName[] references;
    }

    /// <summary>
    /// Helper to manage a collection of assemblies.
    /// Resolves references between assemblies and determines which
    /// additional assemblies need to be extracted.
    /// </summary>
    class AssemblyList
    {
        class AssemblyNameComparer : IEqualityComparer<AssemblyName>
        {
            bool IEqualityComparer<AssemblyName>.Equals(AssemblyName? x, AssemblyName? y) =>
                object.ReferenceEquals(x, y) ||
                x?.Name == y?.Name && x?.Version == y?.Version;

            int IEqualityComparer<AssemblyName>.GetHashCode(AssemblyName obj) =>
                (obj.Name, obj.Version).GetHashCode();
        }

        readonly Dictionary<AssemblyName, AssemblyInfo> assembliesRead = new Dictionary<AssemblyName, AssemblyInfo>(new AssemblyNameComparer());

        public void AddFile(string assemblyPath, bool extractAll)
        {
            if (!filesAnalyzed.Contains(assemblyPath))
            {
                filesAnalyzed.Add(assemblyPath);
                try
                {
                    var info = new AssemblyInfo(assemblyPath);
                    info.extract = extractAll;
                    if (!assembliesRead.ContainsKey(info.name))
                        assembliesRead.Add(info.name, info);
                }
                catch (InvalidAssemblyException)
                { }
            }
        }

        public IEnumerable<AssemblyInfo> AssembliesToExtract => assembliesRead.Values.Where(info => info.extract);

        IEnumerable<AssemblyName> AssembliesToReference => AssembliesToExtract.SelectMany(info => info.references);

        public void ResolveReferences()
        {
            var assembliesToReference = new Stack<AssemblyName>(AssembliesToReference);

            while (assembliesToReference.Any())
            {
                var item = assembliesToReference.Pop();
                if (assembliesRead.TryGetValue(item, out AssemblyInfo? info))
                {
                    if (!info.extract)
                    {
                        info.extract = true;
                        foreach (var reference in info.references)
                            assembliesToReference.Push(reference);
                    }
                }
                else
                {
                    missingReferences.Add(item);
                }
            }
        }

        readonly HashSet<string> filesAnalyzed = new HashSet<string>();
        public readonly HashSet<AssemblyName> missingReferences = new HashSet<AssemblyName>();
    }

    /// <summary>
    /// Parses the command line and collates a list of DLLs/EXEs to extract.
    /// </summary>
    class ExtractorOptions
    {
        readonly AssemblyList assemblyList = new AssemblyList();

        private ExtractorOptions(string[] args)
        {
            Verbosity = Verbosity.Info;
            Threads = System.Environment.ProcessorCount;
            PDB = true;
            TrapCompression = TrapWriter.CompressionMode.Gzip;

            ParseArgs(args);

            AddFrameworkDirectories(false);

            assemblyList.ResolveReferences();
            AssembliesToExtract = assemblyList.AssembliesToExtract.ToArray();
        }

        public void AddDirectory(string directory, bool extractAll)
        {
            foreach (var file in
                Directory.EnumerateFiles(directory, "*.dll", SearchOption.AllDirectories).
                Concat(Directory.EnumerateFiles(directory, "*.exe", SearchOption.AllDirectories)))
            {
                assemblyList.AddFile(file, extractAll);
            }
        }

        void AddFrameworkDirectories(bool extractAll)
        {
            AddDirectory(RuntimeEnvironment.GetRuntimeDirectory(), extractAll);
        }

        public Verbosity Verbosity { get; private set; }
        public bool NoCache { get; private set; }
        public int Threads { get; private set; }
        public bool PDB { get; private set; }
        public TrapWriter.CompressionMode TrapCompression { get; private set; }

        void AddFileOrDirectory(string path)
        {
            path = Path.GetFullPath(path);
            if (File.Exists(path))
            {
                assemblyList.AddFile(path, true);
                string? directory = Path.GetDirectoryName(path);
                if (directory is null)
                {
                    throw new InternalError($"Directory of path '{path}' is null");
                }
                AddDirectory(directory, false);
            }
            else if (Directory.Exists(path))
            {
                AddDirectory(path, true);
            }
        }

        public IEnumerable<AssemblyInfo> AssembliesToExtract { get; }

        /// <summary>
        /// Gets the assemblies that were referenced but were not available to be
        /// extracted. This is not an error, it just means that the database is not
        /// as complete as it could be.
        /// </summary>
        public IEnumerable<AssemblyName> MissingReferences => assemblyList.missingReferences;

        public static ExtractorOptions ParseCommandLine(string[] args)
        {
            var options = new ExtractorOptions(args);

            return options;
        }

        private void ParseArgs(string[] args)
        {
            foreach (var arg in args)
            {
                if (arg == "--verbose")
                {
                    Verbosity = Verbosity.All;
                }
                else if (arg == "--silent")
                {
                    Verbosity = Verbosity.Off;
                }
                else if (arg.StartsWith("--verbosity:"))
                {
                    Verbosity = (Verbosity)int.Parse(arg.Substring(12));
                }
                else if (arg == "--dotnet")
                {
                    AddFrameworkDirectories(true);
                }
                else if (arg == "--nocache")
                {
                    NoCache = true;
                }
                else if (arg.StartsWith("--threads:"))
                {
                    Threads = int.Parse(arg.Substring(10));
                }
                else if (arg == "--no-pdb")
                {
                    PDB = false;
                }
                else
                {
                    AddFileOrDirectory(arg);
                }
            }
        }
    }
}
