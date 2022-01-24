using Semmle.Extraction.CIL.Entities;
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection.Metadata;

namespace Semmle.Extraction.CIL
{
    /// <summary>
    /// Provides methods for creating and caching various entities.
    /// </summary>
    internal sealed partial class Context
    {
        private readonly Dictionary<object, Label> ids = new Dictionary<object, Label>();

        internal T Populate<T>(T e) where T : IExtractedEntity
        {
            if (e.Label.Valid)
            {
                return e;   // Already populated
            }

            if (ids.TryGetValue(e, out var existing))
            {
                // It exists already
                e.Label = existing;
            }
            else
            {
                e.Label = GetNewLabel();
                DefineLabel(e);
                ids.Add(e, e.Label);
                PopulateLater(() =>
                {
                    foreach (var c in e.Contents)
                        c.Extract(this);
                });
#if DEBUG_LABELS
                using var writer = new EscapingTextWriter();
                e.WriteId(writer);
                var id = writer.ToString();

                if (debugLabels.TryGetValue(id, out var previousEntity))
                {
                    Extractor.Message(new Message("Duplicate trap ID", id, null, severity: Util.Logging.Severity.Warning));
                }
                else
                {
                    debugLabels.Add(id, e);
                }
#endif
            }
            return e;
        }

#if DEBUG_LABELS
        private readonly Dictionary<string, IExtractedEntity> debugLabels = new Dictionary<string, IExtractedEntity>();
#endif

        public IExtractedEntity Create(Handle h)
        {
            var entity = CreateGeneric(defaultGenericContext, h);
            return entity;
        }

        // Lazily cache primitive types.
        private readonly PrimitiveType[] primitiveTypes = new PrimitiveType[(int)PrimitiveTypeCode.Object + 1];

        public PrimitiveType Create(PrimitiveTypeCode code)
        {
            var e = primitiveTypes[(int)code];

            if (e is null)
            {
                e = new PrimitiveType(this, code)
                {
                    Label = GetNewLabel()
                };
                DefineLabel(e);
                primitiveTypes[(int)code] = e;
            }

            return e;
        }

        /// <summary>
        /// Creates an entity from a Handle in a GenericContext.
        /// The type of the returned entity depends on the type of the handle.
        /// The GenericContext is needed because some handles are generics which
        /// need to be expanded in terms of the current instantiation. If this sounds
        /// complex, you are right.
        ///
        /// The pair (h,genericContext) is cached in case it is needed again.
        /// </summary>
        /// <param name="h">The handle of the entity.</param>
        /// <param name="genericContext">The generic context.</param>
        /// <returns></returns>
        public IExtractedEntity CreateGeneric(IGenericContext genericContext, Handle h) => genericHandleFactory[genericContext, h];

        private readonly IGenericContext defaultGenericContext;

        private IExtractedEntity CreateGenericHandle(IGenericContext gc, Handle handle)
        {
            IExtractedEntity entity;
            switch (handle.Kind)
            {
                case HandleKind.MethodDefinition:
                    entity = new DefinitionMethod(gc, (MethodDefinitionHandle)handle);
                    break;
                case HandleKind.MemberReference:
                    entity = Create(gc, (MemberReferenceHandle)handle);
                    break;
                case HandleKind.MethodSpecification:
                    entity = new MethodSpecificationMethod(gc, (MethodSpecificationHandle)handle);
                    break;
                case HandleKind.FieldDefinition:
                    entity = new DefinitionField(gc.Context, (FieldDefinitionHandle)handle);
                    break;
                case HandleKind.TypeReference:
                    var tr = new TypeReferenceType(this, (TypeReferenceHandle)handle);
                    if (tr.TryGetPrimitiveType(out var pt))
                        // Map special names like `System.Int32` to `int`
                        return pt;
                    entity = tr;
                    break;
                case HandleKind.TypeSpecification:
                    return Entities.Type.DecodeType(gc, (TypeSpecificationHandle)handle);
                case HandleKind.TypeDefinition:
                    entity = new TypeDefinitionType(this, (TypeDefinitionHandle)handle);
                    break;
                case HandleKind.StandaloneSignature:
                    var signature = MdReader.GetStandaloneSignature((StandaloneSignatureHandle)handle);
                    var method = signature.DecodeMethodSignature(gc.Context.TypeSignatureDecoder, gc);
                    entity = new FunctionPointerType(this, method);
                    break;
                default:
                    throw new InternalError("Unhandled handle kind " + handle.Kind);
            }

            Populate(entity);
            return entity;
        }

        private IExtractedEntity Create(IGenericContext gc, MemberReferenceHandle handle)
        {
            var mr = MdReader.GetMemberReference(handle);
            switch (mr.GetKind())
            {
                case MemberReferenceKind.Method:
                    return new MemberReferenceMethod(gc, handle);
                case MemberReferenceKind.Field:
                    return new MemberReferenceField(gc, handle);
                default:
                    throw new InternalError("Unhandled member reference handle");
            }
        }

        /// <summary>
        /// Gets the string for a string handle.
        /// </summary>
        /// <param name="h">The string handle.</param>
        /// <returns>The string.</returns>
        public string GetString(StringHandle h) => MdReader.GetString(h);

        #region Namespaces

        private readonly CachedFunction<StringHandle, Namespace> namespaceFactory;

        public Namespace CreateNamespace(StringHandle fqn) => namespaceFactory[fqn];

        private readonly Lazy<Namespace> globalNamespace, systemNamespace;

        /// <summary>
        /// The entity representing the global namespace.
        /// </summary>
        public Namespace GlobalNamespace => globalNamespace.Value;

        /// <summary>
        /// The entity representing the System namespace.
        /// </summary>
        public Namespace SystemNamespace => systemNamespace.Value;

        /// <summary>
        /// Creates a namespace from a fully-qualified name.
        /// </summary>
        /// <param name="fqn">The fully-qualified namespace name.</param>
        /// <returns>The namespace entity.</returns>
        private Namespace CreateNamespace(string fqn) => Populate(new Namespace(this, fqn));

        private readonly CachedFunction<NamespaceDefinitionHandle, Namespace> namespaceDefinitionFactory;

        /// <summary>
        /// Creates a namespace from a namespace handle.
        /// </summary>
        /// <param name="handle">The handle of the namespace.</param>
        /// <returns>The namespace entity.</returns>
        public Namespace Create(NamespaceDefinitionHandle handle) => namespaceDefinitionFactory[handle];

        private Namespace CreateNamespace(NamespaceDefinitionHandle handle)
        {
            if (handle.IsNil)
                return GlobalNamespace;
            var nd = MdReader.GetNamespaceDefinition(handle);
            return Populate(new Namespace(this, GetString(nd.Name), Create(nd.Parent)));
        }
        #endregion

        #region Locations
        private readonly CachedFunction<PDB.ISourceFile, PdbSourceFile> sourceFiles;
        private readonly CachedFunction<PathTransformer.ITransformedPath, Folder> folders;
        private readonly CachedFunction<PDB.Location, PdbSourceLocation> sourceLocations;

        /// <summary>
        /// Creates a source file entity from a PDB source file.
        /// </summary>
        /// <param name="file">The PDB source file.</param>
        /// <returns>A source file entity.</returns>
        public PdbSourceFile CreateSourceFile(PDB.ISourceFile file) => sourceFiles[file];

        /// <summary>
        /// Creates a folder entitiy with the given path.
        /// </summary>
        /// <param name="path">The path of the folder.</param>
        /// <returns>A folder entity.</returns>
        public Folder CreateFolder(PathTransformer.ITransformedPath path) => folders[path];

        /// <summary>
        /// Creates a source location.
        /// </summary>
        /// <param name="loc">The source location from PDB.</param>
        /// <returns>A source location entity.</returns>
        public PdbSourceLocation CreateSourceLocation(PDB.Location loc) => sourceLocations[loc];

        #endregion

        private readonly CachedFunction<IGenericContext, Handle, IExtractedEntity> genericHandleFactory;

        /// <summary>
        /// Gets the short name of a member, without the preceding interface qualifier.
        /// </summary>
        /// <param name="handle">The handle of the name.</param>
        /// <returns>The short name.</returns>
        public string ShortName(StringHandle handle)
        {
            var str = MdReader.GetString(handle);
            if (str.EndsWith(".ctor"))
                return ".ctor";
            if (str.EndsWith(".cctor"))
                return ".cctor";
            var dot = str.LastIndexOf('.');
            return dot == -1 ? str : str.Substring(dot + 1);
        }
    }
}
