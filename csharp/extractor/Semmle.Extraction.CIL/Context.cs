using System;
using System.IO;
using System.Reflection.Metadata;
using System.Reflection.PortableExecutable;

namespace Semmle.Extraction.CIL
{
    /// <summary>
    /// Extraction context for CIL extraction.
    /// Adds additional context that is specific for CIL extraction.
    /// One context = one DLL/EXE.
    /// </summary>
    internal sealed partial class Context : Extraction.Context, IDisposable
    {
        private readonly FileStream stream;
        private Entities.Assembly? assemblyNull;
        public MetadataReader MdReader { get; }
        public PEReader PeReader { get; }
        public string AssemblyPath { get; }
        public Entities.Assembly Assembly
        {
            get { return assemblyNull!; }
            set { assemblyNull = value; }
        }
        public PDB.IPdb? Pdb { get; }

        public Context(Extractor extractor, TrapWriter trapWriter, string assemblyPath, bool extractPdbs)
            : base(extractor, trapWriter)
        {
            this.AssemblyPath = assemblyPath;
            stream = File.OpenRead(assemblyPath);
            PeReader = new PEReader(stream, PEStreamOptions.PrefetchEntireImage);
            MdReader = PeReader.GetMetadataReader();
            TypeSignatureDecoder = new Entities.TypeSignatureDecoder(this);

            globalNamespace = new Lazy<Entities.Namespace>(() => Populate(new Entities.Namespace(this, "", null)));
            systemNamespace = new Lazy<Entities.Namespace>(() => Populate(new Entities.Namespace(this, "System")));
            genericHandleFactory = new CachedFunction<IGenericContext, Handle, IExtractedEntity>(CreateGenericHandle);
            namespaceFactory = new CachedFunction<StringHandle, Entities.Namespace>(n => CreateNamespace(MdReader.GetString(n)));
            namespaceDefinitionFactory = new CachedFunction<NamespaceDefinitionHandle, Entities.Namespace>(CreateNamespace);
            sourceFiles = new CachedFunction<PDB.ISourceFile, Entities.PdbSourceFile>(path => new Entities.PdbSourceFile(this, path));
            folders = new CachedFunction<PathTransformer.ITransformedPath, Entities.Folder>(path => new Entities.Folder(this, path));
            sourceLocations = new CachedFunction<PDB.Location, Entities.PdbSourceLocation>(location => new Entities.PdbSourceLocation(this, location));

            defaultGenericContext = new EmptyContext(this);

            if (extractPdbs)
            {
                Pdb = PDB.PdbReader.Create(assemblyPath, PeReader);
                if (Pdb is not null)
                {
                    Extractor.Logger.Log(Util.Logging.Severity.Info, string.Format("Found PDB information for {0}", assemblyPath));
                }
            }
        }

        public void Dispose()
        {
            if (Pdb is not null)
                Pdb.Dispose();
            PeReader.Dispose();
            stream.Dispose();
        }

        /// <summary>
        /// Extract the contents of a given entity.
        /// </summary>
        /// <param name="entity">The entity to extract.</param>
        public void Extract(IExtractedEntity entity)
        {
            foreach (var content in entity.Contents)
            {
                content.Extract(this);
            }
        }

        public void WriteAssemblyPrefix(TextWriter trapFile)
        {
            var def = MdReader.GetAssemblyDefinition();
            trapFile.Write(GetString(def.Name));
            trapFile.Write('_');
            trapFile.Write(def.Version.ToString());
            trapFile.Write(Entities.Type.AssemblyTypeNameSeparator);
        }

        public Entities.TypeSignatureDecoder TypeSignatureDecoder { get; }

        /// <summary>
        /// A type used to signify something we can't handle yet.
        /// Specifically, function pointers (used in C++).
        /// </summary>
        public Entities.Type ErrorType
        {
            get
            {
                var errorType = new Entities.ErrorType(this);
                Populate(errorType);
                return errorType;
            }
        }

        /// <summary>
        /// Attempt to locate debugging information for a particular method.
        ///
        ///     Returns null on failure, for example if there was no PDB information found for the
        ///     DLL, or if the particular method is compiler generated or doesn't come from source code.
        /// </summary>
        /// <param name="handle">The handle of the method.</param>
        /// <returns>The debugging information, or null if the information could not be located.</returns>
        public PDB.Method? GetMethodDebugInformation(MethodDefinitionHandle handle)
        {
            return Pdb?.GetMethod(handle.ToDebugInformationHandle());
        }
    }
}
