using System;
using System.Collections.Generic;
using System.Reflection.Metadata;

namespace Semmle.Extraction.CIL
{
    /// <summary>
    /// Provides methods for creating and caching various entities.
    /// </summary>
    public partial class Context
    {
        readonly Dictionary<Id, (Label, Id)> ids = new Dictionary<Id, (Label, Id)>();

        public T Populate<T>(T e) where T : ILabelledEntity
        {
            Id id = e.ShortId;

            if (ids.TryGetValue(id, out var existing))
            {
                // It exists already
                e.Label = existing.Item1;
                e.ShortId = existing.Item2;   // Reuse ID for efficiency
            }
            else
            {
                e.Label = cx.GetNewLabel();
                cx.DefineLabel(e, cx.TrapWriter.Writer);
                ids.Add(id, (e.Label, id));
                cx.PopulateLater(() =>
                {
                    foreach (var c in e.Contents)
                        c.Extract(this);
                });
            }
            return e;
        }

        public IExtractedEntity Create(Handle h)
        {
            var entity = CreateGeneric(defaultGenericContext, h);
            return entity;
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
        public ILabelledEntity CreateGeneric(GenericContext genericContext, Handle h) => genericHandleFactory[genericContext, h];

        readonly GenericContext defaultGenericContext;

        ILabelledEntity CreateGenericHandle(GenericContext gc, Handle handle)
        {
            ILabelledEntity entity;
            switch (handle.Kind)
            {
                case HandleKind.MethodDefinition:
                    entity = new Entities.DefinitionMethod(gc, (MethodDefinitionHandle)handle);
                    break;
                case HandleKind.MemberReference:
                    entity = Create(gc, (MemberReferenceHandle)handle);
                    break;
                case HandleKind.MethodSpecification:
                    entity = new Entities.MethodSpecificationMethod(gc, (MethodSpecificationHandle)handle);
                    break;
                case HandleKind.FieldDefinition:
                    entity = new Entities.DefinitionField(gc, (FieldDefinitionHandle)handle);
                    break;
                case HandleKind.TypeReference:
                    entity = new Entities.TypeReferenceType(this, (TypeReferenceHandle)handle);
                    break;
                case HandleKind.TypeSpecification:
                    entity = new Entities.TypeSpecificationType(gc, (TypeSpecificationHandle)handle);
                    break;
                case HandleKind.TypeDefinition:
                    entity = new Entities.TypeDefinitionType(this, (TypeDefinitionHandle)handle);
                    break;
                default:
                    throw new InternalError("Unhandled handle kind " + handle.Kind);
            }

            Populate(entity);
            return entity;
        }

        ILabelledEntity Create(GenericContext gc, MemberReferenceHandle handle)
        {
            var mr = mdReader.GetMemberReference(handle);
            switch (mr.GetKind())
            {
                case MemberReferenceKind.Method:
                    return new Entities.MemberReferenceMethod(gc, handle);
                case MemberReferenceKind.Field:
                    return new Entities.MemberReferenceField(gc, handle);
                default:
                    throw new InternalError("Unhandled member reference handle");
            }
        }

        #region Strings
        readonly Dictionary<StringHandle, StringId> stringHandleIds = new Dictionary<StringHandle, StringId>();
        readonly Dictionary<string, StringId> stringIds = new Dictionary<string, StringId>();

        /// <summary>
        /// Return an ID containing the given string.
        /// </summary>
        /// <param name="h">The string handle.</param>
        /// <returns>An ID.</returns>
        public StringId GetId(StringHandle h)
        {
            StringId result;
            if (!stringHandleIds.TryGetValue(h, out result))
            {
                result = new StringId(mdReader.GetString(h));
                stringHandleIds.Add(h, result);
            }
            return result;
        }

        public readonly StringId Dot = new StringId(".");

        /// <summary>
        /// Gets an ID containing the given string.
        /// Caches existing IDs for more compact storage.
        /// </summary>
        /// <param name="str">The string.</param>
        /// <returns>An ID containing the string.</returns>
        public StringId GetId(string str)
        {
            StringId result;
            if (!stringIds.TryGetValue(str, out result))
            {
                result = new StringId(str);
                stringIds.Add(str, result);
            }
            return result;
        }
        #endregion

        #region Namespaces

        readonly CachedFunction<StringHandle, Entities.Namespace> namespaceFactory;

        public Entities.Namespace CreateNamespace(StringHandle fqn) => namespaceFactory[fqn];

        readonly Lazy<Entities.Namespace> globalNamespace, systemNamespace;

        /// <summary>
        /// The entity representing the global namespace.
        /// </summary>
        public Entities.Namespace GlobalNamespace => globalNamespace.Value;

        /// <summary>
        /// The entity representing the System namespace.
        /// </summary>
        public Entities.Namespace SystemNamespace => systemNamespace.Value;

        /// <summary>
        /// Creates a namespace from a fully-qualified name.
        /// </summary>
        /// <param name="fqn">The fully-qualified namespace name.</param>
        /// <returns>The namespace entity.</returns>
        Entities.Namespace CreateNamespace(string fqn) => Populate(new Entities.Namespace(this, fqn));

        readonly CachedFunction<NamespaceDefinitionHandle, Entities.Namespace> namespaceDefinitionFactory;

        /// <summary>
        /// Creates a namespace from a namespace handle.
        /// </summary>
        /// <param name="handle">The handle of the namespace.</param>
        /// <returns>The namespace entity.</returns>
        public Entities.Namespace Create(NamespaceDefinitionHandle handle) => namespaceDefinitionFactory[handle];

        Entities.Namespace CreateNamespace(NamespaceDefinitionHandle handle)
        {
            if (handle.IsNil) return GlobalNamespace;
            NamespaceDefinition nd = mdReader.GetNamespaceDefinition(handle);
            return Populate(new Entities.Namespace(this, GetId(nd.Name), Create(nd.Parent)));
        }
        #endregion

        #region Locations
        readonly CachedFunction<PDB.ISourceFile, Entities.PdbSourceFile> sourceFiles;
        readonly CachedFunction<string, Entities.Folder> folders;
        readonly CachedFunction<PDB.Location, Entities.PdbSourceLocation> sourceLocations;

        /// <summary>
        /// Creates a source file entity from a PDB source file.
        /// </summary>
        /// <param name="file">The PDB source file.</param>
        /// <returns>A source file entity.</returns>
        public Entities.PdbSourceFile CreateSourceFile(PDB.ISourceFile file) => sourceFiles[file];

        /// <summary>
        /// Creates a folder entitiy with the given path.
        /// </summary>
        /// <param name="path">The path of the folder.</param>
        /// <returns>A folder entity.</returns>
        public Entities.Folder CreateFolder(string path) => folders[path];

        /// <summary>
        /// Creates a source location.
        /// </summary>
        /// <param name="loc">The source location from PDB.</param>
        /// <returns>A source location entity.</returns>
        public Entities.PdbSourceLocation CreateSourceLocation(PDB.Location loc) => sourceLocations[loc];

        #endregion

        readonly CachedFunction<GenericContext, Handle, ILabelledEntity> genericHandleFactory;

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
