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
    public partial class Context
    {
        readonly Dictionary<object, Label> ids = new Dictionary<object, Label>();

        public T Populate<T>(T e) where T : IExtractedEntity
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
                e.Label = cx.GetNewLabel();
                cx.DefineLabel(e, cx.TrapWriter.Writer, cx.Extractor);
                ids.Add(e, e.Label);
                cx.PopulateLater(() =>
                {
                    foreach (var c in e.Contents)
                        c.Extract(this);
                });
#if DEBUG_LABELS
                using var writer = new StringWriter();
                e.WriteId(writer);
                var id = writer.ToString();

                if (debugLabels.TryGetValue(id, out IExtractedEntity? previousEntity))
                {
                    cx.Extractor.Message(new Message("Duplicate trap ID", id, null, severity: Util.Logging.Severity.Warning));
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
            PrimitiveType e = primitiveTypes[(int)code];

            if (e is null)
            {
                e = new PrimitiveType(this, code)
                {
                    Label = cx.GetNewLabel()
                };
                cx.DefineLabel(e, cx.TrapWriter.Writer, cx.Extractor);
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
        public IExtractedEntity CreateGeneric(GenericContext genericContext, Handle h) => genericHandleFactory[genericContext, h];

        readonly GenericContext defaultGenericContext;

        IExtractedEntity CreateGenericHandle(GenericContext gc, Handle handle)
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
                    entity = new DefinitionField(gc, (FieldDefinitionHandle)handle);
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
                default:
                    throw new InternalError("Unhandled handle kind " + handle.Kind);
            }

            Populate(entity);
            return entity;
        }

        IExtractedEntity Create(GenericContext gc, MemberReferenceHandle handle)
        {
            var mr = mdReader.GetMemberReference(handle);
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
        public string GetString(StringHandle h) => mdReader.GetString(h);

        #region Namespaces

        readonly CachedFunction<StringHandle, Namespace> namespaceFactory;

        public Namespace CreateNamespace(StringHandle fqn) => namespaceFactory[fqn];

        readonly Lazy<Namespace> globalNamespace, systemNamespace;

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
        Namespace CreateNamespace(string fqn) => Populate(new Namespace(this, fqn));

        readonly CachedFunction<NamespaceDefinitionHandle, Namespace> namespaceDefinitionFactory;

        /// <summary>
        /// Creates a namespace from a namespace handle.
        /// </summary>
        /// <param name="handle">The handle of the namespace.</param>
        /// <returns>The namespace entity.</returns>
        public Namespace Create(NamespaceDefinitionHandle handle) => namespaceDefinitionFactory[handle];

        Namespace CreateNamespace(NamespaceDefinitionHandle handle)
        {
            if (handle.IsNil) return GlobalNamespace;
            NamespaceDefinition nd = mdReader.GetNamespaceDefinition(handle);
            return Populate(new Namespace(this, GetString(nd.Name), Create(nd.Parent)));
        }
        #endregion

        #region Locations
        readonly CachedFunction<PDB.ISourceFile, PdbSourceFile> sourceFiles;
        readonly CachedFunction<string, Folder> folders;
        readonly CachedFunction<PDB.Location, PdbSourceLocation> sourceLocations;

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
        public Folder CreateFolder(string path) => folders[path];

        /// <summary>
        /// Creates a source location.
        /// </summary>
        /// <param name="loc">The source location from PDB.</param>
        /// <returns>A source location entity.</returns>
        public PdbSourceLocation CreateSourceLocation(PDB.Location loc) => sourceLocations[loc];

        #endregion

        readonly CachedFunction<GenericContext, Handle, IExtractedEntity> genericHandleFactory;

        /// <summary>
        /// Gets the short name of a member, without the preceding interface qualifier.
        /// </summary>
        /// <param name="handle">The handle of the name.</param>
        /// <returns>The short name.</returns>
        public string ShortName(StringHandle handle)
        {
            string str = mdReader.GetString(handle);
            if (str.EndsWith(".ctor")) return ".ctor";
            if (str.EndsWith(".cctor")) return ".cctor";
            var dot = str.LastIndexOf('.');
            return dot == -1 ? str : str.Substring(dot + 1);
        }
    }
}
