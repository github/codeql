using System;
using Microsoft.CodeAnalysis;
using System.Reflection.Metadata;
using System.Collections.Immutable;
using System.Linq;
using System.Collections.Generic;
using System.Reflection;
using Semmle.Util;
using System.IO;
using System.Diagnostics.CodeAnalysis;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A type.
    /// </summary>
    internal interface IType : IEntity
    {
    }

    /// <summary>
    /// An array type.
    /// </summary>
    internal interface IArrayType : IType
    {
    }

    /// <summary>
    /// The CIL database type-kind.
    /// </summary>
    public enum CilTypeKind
    {
        ValueOrRefType,
        TypeParameter,
        Array,
        Pointer
    }

    /// <summary>
    /// A type container (namespace/types/method).
    /// </summary>
    internal interface ITypeContainer : IExtractedEntity
    {
    }

    /// <summary>
    /// Base class for all type containers (namespaces, types, methods).
    /// </summary>
    public abstract class TypeContainer : GenericContext, ITypeContainer
    {
        protected TypeContainer(Context cx) : base(cx)
        {
        }

        public virtual Label Label { get; set; }

        public abstract void WriteId(TextWriter trapFile);

        public void WriteQuotedId(TextWriter trapFile)
        {
            trapFile.Write("@\"");
            WriteId(trapFile);
            trapFile.Write(IdSuffix);
            trapFile.Write('\"');
        }

        public abstract string IdSuffix { get; }

        Location IEntity.ReportingLocation => throw new NotImplementedException();

        public void Extract(Context cx2) { cx2.Populate(this); }

        public abstract IEnumerable<IExtractionProduct> Contents { get; }

        public override string ToString()
        {
            using var writer = new StringWriter();
            WriteQuotedId(writer);
            return writer.ToString();
        }

        TrapStackBehaviour IEntity.TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }

    /// <summary>
    /// A type.
    /// </summary>
    public abstract class Type : TypeContainer, IMember, IType
    {
        public override string IdSuffix => ";cil-type";

        public sealed override void WriteId(TextWriter trapFile) => WriteId(trapFile, false);

        /// <summary>
        /// Find the method in this type matching the name and signature.
        /// </summary>
        /// <param name="methodName">The handle to the name.</param>
        /// <param name="signature">
        /// The handle to the signature. Note that comparing handles is a valid
        /// shortcut to comparing the signature bytes since handles are unique.
        /// </param>
        /// <returns>The method, or 'null' if not found or not supported.</returns>
        internal virtual Method? LookupMethod(StringHandle methodName, BlobHandle signature)
        {
            return null;
        }

        public IEnumerable<Type> TypeArguments
        {
            get
            {
                if (ContainingType != null)
                {
                    foreach (var t in ContainingType.TypeArguments)
                        yield return t;
                }
                foreach (var t in ThisTypeArguments)
                    yield return t;

            }
        }

        public virtual IEnumerable<Type> ThisTypeArguments
        {
            get
            {
                yield break;
            }
        }

        /// <summary>
        /// Writes the assembly identifier of this type.
        /// </summary>
        public abstract void WriteAssemblyPrefix(TextWriter trapFile);

        /// <summary>
        /// Writes the ID part to be used in a method ID.
        /// </summary>
        /// <param name="inContext">
        /// Whether we should output the context prefix of type parameters.
        /// (This is to avoid infinite recursion generating a method ID that returns a
        /// type parameter.)
        /// </param>
        public abstract void WriteId(TextWriter trapFile, bool inContext);

        public void GetId(TextWriter trapFile, bool inContext)
        {
            if (inContext)
                WriteId(trapFile, true);
            else
                WriteId(trapFile);
        }

        protected Type(Context cx) : base(cx) { }

        public abstract CilTypeKind Kind
        {
            get;
        }

        public virtual TypeContainer Parent => (TypeContainer?)ContainingType ?? Namespace!;

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.cil_type(this, Name, Kind, Parent, SourceDeclaration);
            }
        }

        /// <summary>
        /// Whether this type is visible outside the current assembly.
        /// </summary>
        public virtual bool IsVisible => true;

        public abstract string Name { get; }

        public abstract Namespace? Namespace { get; }

        public abstract Type? ContainingType { get; }

        public abstract Type Construct(IEnumerable<Type> typeArguments);

        /// <summary>
        /// The number of type arguments, or 0 if this isn't generic.
        /// The containing type may also have type arguments.
        /// </summary>
        public abstract int ThisTypeParameters { get; }

        /// <summary>
        /// The total number of type parameters (including parent types).
        /// This is used for internal consistency checking only.
        /// </summary>
        public int TotalTypeParametersCheck =>
            ContainingType == null ? ThisTypeParameters : ThisTypeParameters + ContainingType.TotalTypeParametersCheck;

        /// <summary>
        /// Returns all bound/unbound generic arguments
        /// of a constructed/unbound generic type.
        /// </summary>
        public virtual IEnumerable<Type> ThisGenericArguments
        {
            get
            {
                yield break;
            }
        }

        public virtual IEnumerable<Type> GenericArguments
        {
            get
            {
                if (ContainingType != null)
                {
                    foreach (var t in ContainingType.GenericArguments)
                        yield return t;
                }
                foreach (var t in ThisGenericArguments)
                    yield return t;
            }
        }

        public virtual Type SourceDeclaration => this;

        public void PrimitiveTypeId(TextWriter trapFile)
        {
            trapFile.Write("builtin:");
            trapFile.Write(Name);
        }

        /// <summary>
        /// Gets the primitive type corresponding to this type, if possible.
        /// </summary>
        /// <param name="t">The resulting primitive type, or null.</param>
        /// <returns>True if this type is a primitive type.</returns>
        public bool TryGetPrimitiveType([NotNullWhen(true)] out PrimitiveType? t)
        {
            if (TryGetPrimitiveTypeCode(out var code))
            {
                t = Cx.Create(code);
                return true;
            }

            t = null;
            return false;
        }

        private bool TryGetPrimitiveTypeCode(out PrimitiveTypeCode code)
        {
            if (ContainingType == null && Namespace?.Name == Cx.SystemNamespace.Name)
            {
                switch (Name)
                {
                    case "Boolean":
                        code = PrimitiveTypeCode.Boolean;
                        return true;
                    case "Object":
                        code = PrimitiveTypeCode.Object;
                        return true;
                    case "Byte":
                        code = PrimitiveTypeCode.Byte;
                        return true;
                    case "SByte":
                        code = PrimitiveTypeCode.SByte;
                        return true;
                    case "Int16":
                        code = PrimitiveTypeCode.Int16;
                        return true;
                    case "UInt16":
                        code = PrimitiveTypeCode.UInt16;
                        return true;
                    case "Int32":
                        code = PrimitiveTypeCode.Int32;
                        return true;
                    case "UInt32":
                        code = PrimitiveTypeCode.UInt32;
                        return true;
                    case "Int64":
                        code = PrimitiveTypeCode.Int64;
                        return true;
                    case "UInt64":
                        code = PrimitiveTypeCode.UInt64;
                        return true;
                    case "Single":
                        code = PrimitiveTypeCode.Single;
                        return true;
                    case "Double":
                        code = PrimitiveTypeCode.Double;
                        return true;
                    case "String":
                        code = PrimitiveTypeCode.String;
                        return true;
                    case "Void":
                        code = PrimitiveTypeCode.Void;
                        return true;
                    case "IntPtr":
                        code = PrimitiveTypeCode.IntPtr;
                        return true;
                    case "UIntPtr":
                        code = PrimitiveTypeCode.UIntPtr;
                        return true;
                    case "Char":
                        code = PrimitiveTypeCode.Char;
                        return true;
                    case "TypedReference":
                        code = PrimitiveTypeCode.TypedReference;
                        return true;
                }
            }

            code = default(PrimitiveTypeCode);
            return false;
        }

        protected bool IsPrimitiveType => TryGetPrimitiveTypeCode(out _);

        public static Type DecodeType(GenericContext gc, TypeSpecificationHandle handle) =>
            gc.Cx.MdReader.GetTypeSpecification(handle).DecodeSignature(gc.Cx.TypeSignatureDecoder, gc);
    }

    /// <summary>
    /// A type defined in the current assembly.
    /// </summary>
    public sealed class TypeDefinitionType : Type
    {
        private readonly Handle handle;
        private readonly TypeDefinition td;

        public TypeDefinitionType(Context cx, TypeDefinitionHandle handle) : base(cx)
        {
            td = cx.MdReader.GetTypeDefinition(handle);
            this.handle = handle;

            declType =
                td.GetDeclaringType().IsNil ? null :
                (Type)cx.Create(td.GetDeclaringType());

            // Lazy because should happen during population.
            typeParams = new Lazy<IEnumerable<TypeTypeParameter>>(MakeTypeParameters);
        }

        public override bool Equals(object? obj)
        {
            return obj is TypeDefinitionType t && handle.Equals(t.handle);
        }

        public override int GetHashCode() => handle.GetHashCode();

        public override void WriteId(TextWriter trapFile, bool inContext)
        {
            if (IsPrimitiveType)
            {
                PrimitiveTypeId(trapFile);
                return;
            }

            var name = Cx.GetString(td.Name);

            if (ContainingType != null)
            {
                ContainingType.GetId(trapFile, inContext);
                trapFile.Write('.');
            }
            else
            {
                WriteAssemblyPrefix(trapFile);

                var ns = Namespace;
                if (!ns.IsGlobalNamespace)
                {
                    ns.WriteId(trapFile);
                    trapFile.Write('.');
                }
            }

            trapFile.Write(name);
        }

        public override string Name
        {
            get
            {
                var name = Cx.GetString(td.Name);
                var tick = name.IndexOf('`');
                return tick == -1 ? name : name.Substring(0, tick);
            }
        }

        public override Namespace Namespace => Cx.Create(td.NamespaceDefinition);

        private readonly Type? declType;

        public override Type? ContainingType => declType;

        public override int ThisTypeParameters
        {
            get
            {
                var containingType = td.GetDeclaringType();
                var parentTypeParameters = containingType.IsNil ? 0 :
                    Cx.MdReader.GetTypeDefinition(containingType).GetGenericParameters().Count;

                return td.GetGenericParameters().Count - parentTypeParameters;
            }
        }

        public override CilTypeKind Kind => CilTypeKind.ValueOrRefType;

        public override Type Construct(IEnumerable<Type> typeArguments)
        {
            return Cx.Populate(new ConstructedType(Cx, this, typeArguments));
        }

        public override void WriteAssemblyPrefix(TextWriter trapFile)
        {
            var ct = ContainingType;
            if (ct is null)
                Cx.WriteAssemblyPrefix(trapFile);
            else if (IsPrimitiveType)
                trapFile.Write("builtin:");
            else
                ct.WriteAssemblyPrefix(trapFile);
        }

        private IEnumerable<TypeTypeParameter> MakeTypeParameters()
        {
            if (ThisTypeParameters == 0)
                return Enumerable.Empty<TypeTypeParameter>();

            var newTypeParams = new TypeTypeParameter[ThisTypeParameters];
            var genericParams = td.GetGenericParameters();
            var toSkip = genericParams.Count - newTypeParams.Length;

            // Two-phase population because type parameters can be mutually dependent
            for (var i = 0; i < newTypeParams.Length; ++i)
                newTypeParams[i] = Cx.Populate(new TypeTypeParameter(this, this, i));
            for (var i = 0; i < newTypeParams.Length; ++i)
                newTypeParams[i].PopulateHandle(genericParams[i + toSkip]);
            return newTypeParams;
        }

        private readonly Lazy<IEnumerable<TypeTypeParameter>> typeParams;

        public override IEnumerable<Type> MethodParameters => Enumerable.Empty<Type>();

        public override IEnumerable<Type> TypeParameters
        {
            get
            {
                if (declType != null)
                {
                    foreach (var t in declType.TypeParameters)
                        yield return t;
                }

                foreach (var t in typeParams.Value)
                    yield return t;
            }
        }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.metadata_handle(this, Cx.Assembly, handle.GetHashCode());

                foreach (var c in base.Contents) yield return c;

                MakeTypeParameters();

                foreach (var f in td.GetFields())
                {
                    // Populate field if needed
                    yield return Cx.CreateGeneric(this, f);
                }

                foreach (var prop in td.GetProperties())
                {
                    yield return new Property(this, this, prop);
                }

                foreach (var @event in td.GetEvents())
                {
                    yield return new Event(Cx, this, @event);
                }

                foreach (var a in Attribute.Populate(Cx, this, td.GetCustomAttributes()))
                    yield return a;

                foreach (var impl in td.GetMethodImplementations().Select(i => Cx.MdReader.GetMethodImplementation(i)))
                {
                    var m = (Method)Cx.CreateGeneric(this, impl.MethodBody);
                    var decl = (Method)Cx.CreateGeneric(this, impl.MethodDeclaration);

                    yield return m;
                    yield return decl;
                    yield return Tuples.cil_implements(m, decl);
                }

                if (td.Attributes.HasFlag(TypeAttributes.Abstract))
                    yield return Tuples.cil_abstract(this);

                if (td.Attributes.HasFlag(TypeAttributes.Interface))
                    yield return Tuples.cil_interface(this);
                else
                    yield return Tuples.cil_class(this);

                if (td.Attributes.HasFlag(TypeAttributes.Public))
                    yield return Tuples.cil_public(this);

                if (td.Attributes.HasFlag(TypeAttributes.Sealed))
                    yield return Tuples.cil_sealed(this);

                if (td.Attributes.HasFlag(TypeAttributes.HasSecurity))
                    yield return Tuples.cil_security(this);

                // Base types

                if (!td.BaseType.IsNil)
                {
                    var @base = (Type)Cx.CreateGeneric(this, td.BaseType);
                    yield return @base;
                    yield return Tuples.cil_base_class(this, @base);
                }

                foreach (var @interface in td.GetInterfaceImplementations().Select(i => Cx.MdReader.GetInterfaceImplementation(i)))
                {
                    var t = (Type)Cx.CreateGeneric(this, @interface.Interface);
                    yield return t;
                    yield return Tuples.cil_base_interface(this, t);
                }

                // Only type definitions have locations.
                yield return Tuples.cil_type_location(this, Cx.Assembly);
            }
        }

        internal override Method LookupMethod(StringHandle name, BlobHandle signature)
        {
            foreach (var h in td.GetMethods())
            {
                var md = Cx.MdReader.GetMethodDefinition(h);

                if (md.Name == name && md.Signature == signature)
                {
                    return (Method)Cx.Create(h);
                }
            }

            throw new InternalError("Couldn't locate method in type");
        }
    }

    /// <summary>
    /// A type reference, to a type in a referenced assembly.
    /// </summary>
    public sealed class TypeReferenceType : Type
    {
        private readonly TypeReferenceHandle handle;
        private readonly TypeReference tr;
        private readonly Lazy<TypeTypeParameter[]> typeParams;

        public TypeReferenceType(Context cx, TypeReferenceHandle handle) : base(cx)
        {
            this.typeParams = new Lazy<TypeTypeParameter[]>(MakeTypeParameters);
            this.handle = handle;
            this.tr = cx.MdReader.GetTypeReference(handle);
        }

        public override bool Equals(object? obj)
        {
            return obj is TypeReferenceType t && handle.Equals(t.handle);
        }

        public override int GetHashCode()
        {
            return handle.GetHashCode();
        }

        private TypeTypeParameter[] MakeTypeParameters()
        {
            var newTypeParams = new TypeTypeParameter[ThisTypeParameters];
            for (var i = 0; i < newTypeParams.Length; ++i)
            {
                newTypeParams[i] = new TypeTypeParameter(this, this, i);
            }
            return newTypeParams;
        }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                foreach (var tp in typeParams.Value)
                    yield return tp;

                foreach (var c in base.Contents)
                    yield return c;
            }
        }

        public override string Name
        {
            get
            {
                var name = Cx.GetString(tr.Name);
                var tick = name.IndexOf('`');
                return tick == -1 ? name : name.Substring(0, tick);
            }
        }

        public override Namespace Namespace => Cx.CreateNamespace(tr.Namespace);

        public override int ThisTypeParameters
        {
            get
            {
                // Parse the name
                var name = Cx.GetString(tr.Name);
                var tick = name.IndexOf('`');
                return tick == -1 ? 0 : int.Parse(name.Substring(tick + 1));
            }
        }

        public override IEnumerable<Type> ThisGenericArguments
        {
            get
            {
                foreach (var t in typeParams.Value)
                    yield return t;
            }
        }

        public override Type? ContainingType
        {
            get
            {
                if (tr.ResolutionScope.Kind == HandleKind.TypeReference)
                    return (Type)Cx.Create((TypeReferenceHandle)tr.ResolutionScope);
                return null;
            }
        }

        public override CilTypeKind Kind => CilTypeKind.ValueOrRefType;

        public override void WriteAssemblyPrefix(TextWriter trapFile)
        {
            switch (tr.ResolutionScope.Kind)
            {
                case HandleKind.TypeReference:
                    ContainingType!.WriteAssemblyPrefix(trapFile);
                    break;
                case HandleKind.AssemblyReference:
                    var assemblyDef = Cx.MdReader.GetAssemblyReference((AssemblyReferenceHandle)tr.ResolutionScope);
                    trapFile.Write(Cx.GetString(assemblyDef.Name));
                    trapFile.Write('_');
                    trapFile.Write(assemblyDef.Version.ToString());
                    trapFile.Write("::");
                    break;
                default:
                    Cx.WriteAssemblyPrefix(trapFile);
                    break;
            }
        }

        public override IEnumerable<Type> TypeParameters => typeParams.Value;

        public override IEnumerable<Type> MethodParameters => throw new InternalError("This type does not have method parameters");

        public override void WriteId(TextWriter trapFile, bool inContext)
        {
            if (IsPrimitiveType)
            {
                PrimitiveTypeId(trapFile);
                return;
            }

            var ct = ContainingType;
            if (ct != null)
            {
                ct.GetId(trapFile, inContext);
            }
            else
            {
                if (tr.ResolutionScope.Kind == HandleKind.AssemblyReference)
                {
                    WriteAssemblyPrefix(trapFile);
                }

                if (!Namespace.IsGlobalNamespace)
                {
                    Namespace.WriteId(trapFile);
                }
            }

            trapFile.Write('.');
            trapFile.Write(Cx.GetString(tr.Name));
        }

        public override Type Construct(IEnumerable<Type> typeArguments)
        {
            if (TotalTypeParametersCheck != typeArguments.Count())
                throw new InternalError("Mismatched type arguments");

            return Cx.Populate(new ConstructedType(Cx, this, typeArguments));
        }
    }


    /// <summary>
    /// A constructed type.
    /// </summary>
    public sealed class ConstructedType : Type
    {
        private readonly Type unboundGenericType;

        // Either null or notEmpty
        private readonly Type[]? thisTypeArguments;

        public override IEnumerable<Type> ThisTypeArguments => thisTypeArguments.EnumerateNull();

        public override IEnumerable<Type> ThisGenericArguments => thisTypeArguments.EnumerateNull();

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                foreach (var c in base.Contents)
                    yield return c;

                var i = 0;
                foreach (var type in ThisGenericArguments)
                {
                    yield return type;
                    yield return Tuples.cil_type_argument(this, i++, type);
                }
            }
        }

        public override Type SourceDeclaration => unboundGenericType;

        public ConstructedType(Context cx, Type unboundType, IEnumerable<Type> typeArguments) : base(cx)
        {
            var suppliedArgs = typeArguments.Count();
            if (suppliedArgs != unboundType.TotalTypeParametersCheck)
                throw new InternalError("Unexpected number of type arguments in ConstructedType");

            unboundGenericType = unboundType;
            var thisParams = unboundType.ThisTypeParameters;

            if (typeArguments.Count() == thisParams)
            {
                containingType = unboundType.ContainingType;
                thisTypeArguments = typeArguments.ToArray();
            }
            else if (thisParams == 0)
            {
                // all type arguments belong to containing type
                containingType = unboundType.ContainingType!.Construct(typeArguments);
            }
            else
            {
                // some type arguments belong to containing type
                var parentParams = suppliedArgs - thisParams;
                containingType = unboundType.ContainingType!.Construct(typeArguments.Take(parentParams));
                thisTypeArguments = typeArguments.Skip(parentParams).ToArray();
            }
        }

        public override bool Equals(object? obj)
        {
            if (obj is ConstructedType t && Equals(unboundGenericType, t.unboundGenericType) && Equals(containingType, t.containingType))
            {
                if (thisTypeArguments is null)
                    return t.thisTypeArguments is null;
                if (!(t.thisTypeArguments is null))
                    return thisTypeArguments.SequenceEqual(t.thisTypeArguments);
            }
            return false;
        }

        public override int GetHashCode()
        {
            var h = unboundGenericType.GetHashCode();
            h = 13 * h + (containingType is null ? 0 : containingType.GetHashCode());
            if (!(thisTypeArguments is null))
                h = h * 13 + thisTypeArguments.SequenceHash();
            return h;
        }

        private readonly Type? containingType;
        public override Type? ContainingType => containingType;

        public override string Name => unboundGenericType.Name;

        public override Namespace Namespace => unboundGenericType.Namespace!;

        public override int ThisTypeParameters => thisTypeArguments == null ? 0 : thisTypeArguments.Length;

        public override CilTypeKind Kind => unboundGenericType.Kind;

        public override Type Construct(IEnumerable<Type> typeArguments)
        {
            throw new NotImplementedException();
        }

        public override void WriteId(TextWriter trapFile, bool inContext)
        {
            if (ContainingType != null)
            {
                ContainingType.GetId(trapFile, inContext);
                trapFile.Write('.');
            }
            else
            {
                WriteAssemblyPrefix(trapFile);

                if (!Namespace.IsGlobalNamespace)
                {
                    Namespace.WriteId(trapFile);
                    trapFile.Write('.');
                }
            }
            trapFile.Write(unboundGenericType.Name);

            if (thisTypeArguments != null && thisTypeArguments.Any())
            {
                trapFile.Write('<');
                var index = 0;
                foreach (var t in thisTypeArguments)
                {
                    trapFile.WriteSeparator(",", ref index);
                    t.WriteId(trapFile);
                }
                trapFile.Write('>');
            }
        }

        public override void WriteAssemblyPrefix(TextWriter trapFile) => unboundGenericType.WriteAssemblyPrefix(trapFile);

        public override IEnumerable<Type> TypeParameters => GenericArguments;

        public override IEnumerable<Type> MethodParameters => throw new NotImplementedException();
    }

    public sealed class PrimitiveType : Type
    {
        private readonly PrimitiveTypeCode typeCode;
        public PrimitiveType(Context cx, PrimitiveTypeCode tc) : base(cx)
        {
            typeCode = tc;
        }

        public override bool Equals(object? obj)
        {
            return obj is PrimitiveType pt && typeCode == pt.typeCode;
        }

        public override int GetHashCode()
        {
            return 1337 * (int)typeCode;
        }

        public override void WriteId(TextWriter trapFile, bool inContext)
        {
            trapFile.Write("builtin:");
            trapFile.Write(Name);
        }

        public override string Name => typeCode.Id();

        public override Namespace Namespace => Cx.SystemNamespace;

        public override Type? ContainingType => null;

        public override int ThisTypeParameters => 0;

        public override CilTypeKind Kind => CilTypeKind.ValueOrRefType;

        public override void WriteAssemblyPrefix(TextWriter trapFile) { }

        public override IEnumerable<Type> TypeParameters => throw new NotImplementedException();

        public override IEnumerable<Type> MethodParameters => throw new NotImplementedException();

        public override Type Construct(IEnumerable<Type> typeArguments) => throw new NotImplementedException();
    }

    /// <summary>
    /// An array type.
    /// </summary>
    internal sealed class ArrayType : Type, IArrayType
    {
        private readonly Type elementType;
        private readonly int rank;

        public ArrayType(Context cx, Type elementType, int rank) : base(cx)
        {
            this.rank = rank;
            this.elementType = elementType;
        }

        public ArrayType(Context cx, Type elementType) : this(cx, elementType, 1)
        {
        }

        public override bool Equals(object? obj)
        {
            return obj is ArrayType array && elementType.Equals(array.elementType) && rank == array.rank;
        }

        public override int GetHashCode()
        {
            return elementType.GetHashCode() * 5 + rank;
        }

        public override void WriteId(TextWriter trapFile, bool inContext)
        {
            elementType.GetId(trapFile, inContext);
            trapFile.Write('[');
            for (var i = 1; i < rank; ++i)
                trapFile.Write(',');
            trapFile.Write(']');
        }

        public override string Name => elementType.Name + "[]";

        public override Namespace Namespace => Cx.SystemNamespace;

        public override Type? ContainingType => null;

        public override int ThisTypeParameters => elementType.ThisTypeParameters;

        public override CilTypeKind Kind => CilTypeKind.Array;

        public override Type Construct(IEnumerable<Type> typeArguments) => Cx.Populate(new ArrayType(Cx, elementType.Construct(typeArguments)));

        public override Type SourceDeclaration => Cx.Populate(new ArrayType(Cx, elementType.SourceDeclaration));

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                foreach (var c in base.Contents)
                    yield return c;

                yield return Tuples.cil_array_type(this, elementType, rank);
            }
        }

        public override void WriteAssemblyPrefix(TextWriter trapFile) => elementType.WriteAssemblyPrefix(trapFile);

        public override IEnumerable<Type> GenericArguments => elementType.GenericArguments;

        public override IEnumerable<Type> TypeParameters => elementType.TypeParameters;

        public override IEnumerable<Type> MethodParameters => throw new NotImplementedException();
    }

    internal interface ITypeParameter : IType
    {
    }

    internal abstract class TypeParameter : Type, ITypeParameter
    {
        protected readonly GenericContext gc;

        protected TypeParameter(GenericContext gc) : base(gc.Cx)
        {
            this.gc = gc;
        }

        public override Namespace? Namespace => null;

        public override Type? ContainingType => null;

        public override int ThisTypeParameters => 0;

        public override CilTypeKind Kind => CilTypeKind.TypeParameter;

        public override void WriteAssemblyPrefix(TextWriter trapFile) => throw new NotImplementedException();

        public override Type Construct(IEnumerable<Type> typeArguments) => throw new InternalError("Attempt to construct a type parameter");

        public IEnumerable<IExtractionProduct> PopulateHandle(GenericParameterHandle parameterHandle)
        {
            if (!parameterHandle.IsNil)
            {
                var tp = Cx.MdReader.GetGenericParameter(parameterHandle);

                if (tp.Attributes.HasFlag(GenericParameterAttributes.Contravariant))
                    yield return Tuples.cil_typeparam_contravariant(this);
                if (tp.Attributes.HasFlag(GenericParameterAttributes.Covariant))
                    yield return Tuples.cil_typeparam_covariant(this);
                if (tp.Attributes.HasFlag(GenericParameterAttributes.DefaultConstructorConstraint))
                    yield return Tuples.cil_typeparam_new(this);
                if (tp.Attributes.HasFlag(GenericParameterAttributes.ReferenceTypeConstraint))
                    yield return Tuples.cil_typeparam_class(this);
                if (tp.Attributes.HasFlag(GenericParameterAttributes.NotNullableValueTypeConstraint))
                    yield return Tuples.cil_typeparam_struct(this);

                foreach (var constraint in tp.GetConstraints().Select(h => Cx.MdReader.GetGenericParameterConstraint(h)))
                {
                    var t = (Type)Cx.CreateGeneric(this.gc, constraint.Type);
                    yield return t;
                    yield return Tuples.cil_typeparam_constraint(this, t);
                }
            }
        }
    }

    internal sealed class MethodTypeParameter : TypeParameter
    {
        private readonly Method method;
        private readonly int index;

        public override void WriteId(TextWriter trapFile, bool inContext)
        {
            if (!(inContext && method == gc))
            {
                trapFile.WriteSubId(method);
            }
            trapFile.Write("!");
            trapFile.Write(index);
        }

        public override string Name => "!" + index;

        public MethodTypeParameter(GenericContext gc, Method m, int index) : base(gc)
        {
            method = m;
            this.index = index;
        }

        public override bool Equals(object? obj)
        {
            return obj is MethodTypeParameter tp && method.Equals(tp.method) && index == tp.index;
        }

        public override int GetHashCode()
        {
            return method.GetHashCode() * 29 + index;
        }

        public override TypeContainer Parent => method;

        public override IEnumerable<Type> TypeParameters => throw new NotImplementedException();

        public override IEnumerable<Type> MethodParameters => throw new NotImplementedException();

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.cil_type(this, Name, Kind, method, SourceDeclaration);
                yield return Tuples.cil_type_parameter(method, index, this);
            }
        }
    }


    internal sealed class TypeTypeParameter : TypeParameter
    {
        private readonly Type type;
        private readonly int index;

        public TypeTypeParameter(GenericContext cx, Type t, int i) : base(cx)
        {
            index = i;
            type = t;
        }

        public override bool Equals(object? obj)
        {
            return obj is TypeTypeParameter tp && type.Equals(tp.type) && index == tp.index;
        }

        public override int GetHashCode()
        {
            return type.GetHashCode() * 13 + index;
        }

        public override void WriteId(TextWriter trapFile, bool inContext)
        {
            type.WriteId(trapFile, inContext);
            trapFile.Write('!');
            trapFile.Write(index);
        }

        public override TypeContainer Parent => type;
        public override string Name => "!" + index;

        public override IEnumerable<Type> TypeParameters => Enumerable.Empty<Type>();

        public override IEnumerable<Type> MethodParameters => Enumerable.Empty<Type>();

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.cil_type(this, Name, Kind, type, SourceDeclaration);
                yield return Tuples.cil_type_parameter(type, index, this);
            }
        }
    }

    internal interface IPointerType : IType
    {
    }

    internal sealed class PointerType : Type, IPointerType
    {
        private readonly Type pointee;

        public PointerType(Context cx, Type pointee) : base(cx)
        {
            this.pointee = pointee;
        }

        public override bool Equals(object? obj)
        {
            return obj is PointerType pt && pointee.Equals(pt.pointee);
        }


        public override int GetHashCode()
        {
            return pointee.GetHashCode() * 29;
        }

        public override void WriteId(TextWriter trapFile, bool inContext)
        {
            pointee.WriteId(trapFile, inContext);
            trapFile.Write('*');
        }

        public override string Name => pointee.Name + "*";

        public override Namespace? Namespace => pointee.Namespace;

        public override Type? ContainingType => pointee.ContainingType;

        public override TypeContainer Parent => pointee.Parent;

        public override int ThisTypeParameters => 0;

        public override CilTypeKind Kind => CilTypeKind.Pointer;

        public override void WriteAssemblyPrefix(TextWriter trapFile) => pointee.WriteAssemblyPrefix(trapFile);

        public override IEnumerable<Type> TypeParameters => throw new NotImplementedException();

        public override IEnumerable<Type> MethodParameters => throw new NotImplementedException();

        public override Type Construct(IEnumerable<Type> typeArguments) => throw new NotImplementedException();

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                foreach (var c in base.Contents) yield return c;
                yield return Tuples.cil_pointer_type(this, pointee);
            }
        }
    }

    internal sealed class ErrorType : Type
    {
        public ErrorType(Context cx) : base(cx)
        {
        }

        public override void WriteId(TextWriter trapFile, bool inContext) => trapFile.Write("<ErrorType>");

        public override CilTypeKind Kind => CilTypeKind.ValueOrRefType;

        public override string Name => "!error";

        public override Namespace Namespace => Cx.GlobalNamespace;

        public override Type? ContainingType => null;

        public override int ThisTypeParameters => 0;

        public override void WriteAssemblyPrefix(TextWriter trapFile) => throw new NotImplementedException();

        public override IEnumerable<Type> TypeParameters => throw new NotImplementedException();

        public override IEnumerable<Type> MethodParameters => throw new NotImplementedException();

        public override Type Construct(IEnumerable<Type> typeArguments) => throw new NotImplementedException();
    }

    internal interface ITypeSignature
    {
        void WriteId(TextWriter trapFile, GenericContext gc);
    }

    public class SignatureDecoder : ISignatureTypeProvider<ITypeSignature, object>
    {
        private struct Array : ITypeSignature
        {
            private readonly ITypeSignature elementType;
            private readonly ArrayShape shape;

            public Array(ITypeSignature elementType, ArrayShape shape) : this()
            {
                this.elementType = elementType;
                this.shape = shape;
            }

            public void WriteId(TextWriter trapFile, GenericContext gc)
            {
                elementType.WriteId(trapFile, gc);
                trapFile.Write('[');
                for (var i = 1; i < shape.Rank; ++i)
                    trapFile.Write(',');
                trapFile.Write(']');
            }
        }

        private struct ByRef : ITypeSignature
        {
            private readonly ITypeSignature elementType;

            public ByRef(ITypeSignature elementType)
            {
                this.elementType = elementType;
            }

            public void WriteId(TextWriter trapFile, GenericContext gc)
            {
                trapFile.Write("ref ");
                elementType.WriteId(trapFile, gc);
            }
        }

        private struct FnPtr : ITypeSignature
        {

            public void WriteId(TextWriter trapFile, GenericContext gc)
            {
                trapFile.Write("<method signature>");
            }
        }

        ITypeSignature IConstructedTypeProvider<ITypeSignature>.GetArrayType(ITypeSignature elementType, ArrayShape shape) =>
            new Array(elementType, shape);

        ITypeSignature IConstructedTypeProvider<ITypeSignature>.GetByReferenceType(ITypeSignature elementType) =>
            new ByRef(elementType);

        ITypeSignature ISignatureTypeProvider<ITypeSignature, object>.GetFunctionPointerType(MethodSignature<ITypeSignature> signature) =>
            new FnPtr();

        private class Instantiation : ITypeSignature
        {
            private readonly ITypeSignature genericType;
            private readonly ImmutableArray<ITypeSignature> typeArguments;

            public Instantiation(ITypeSignature genericType, ImmutableArray<ITypeSignature> typeArguments)
            {
                this.genericType = genericType;
                this.typeArguments = typeArguments;
            }

            public void WriteId(TextWriter trapFile, GenericContext gc)
            {
                genericType.WriteId(trapFile, gc);
                trapFile.Write('<');
                var index = 0;
                foreach (var arg in typeArguments)
                {
                    trapFile.WriteSeparator(",", ref index);
                    arg.WriteId(trapFile, gc);
                }
                trapFile.Write('>');
            }
        }

        ITypeSignature IConstructedTypeProvider<ITypeSignature>.GetGenericInstantiation(ITypeSignature genericType, ImmutableArray<ITypeSignature> typeArguments) =>
            new Instantiation(genericType, typeArguments);

        private class GenericMethodParameter : ITypeSignature
        {
            private readonly object innerGc;
            private readonly int index;

            public GenericMethodParameter(object innerGc, int index)
            {
                this.innerGc = innerGc;
                this.index = index;
            }

            public void WriteId(TextWriter trapFile, GenericContext outerGc)
            {
                if (!ReferenceEquals(innerGc, outerGc) && innerGc is Method method)
                {
                    trapFile.WriteSubId(method);
                }
                trapFile.Write("M!");
                trapFile.Write(index);
            }
        }

        private class GenericTypeParameter : ITypeSignature
        {
            private readonly int index;

            public GenericTypeParameter(int index)
            {
                this.index = index;
            }

            public void WriteId(TextWriter trapFile, GenericContext gc)
            {
                trapFile.Write("T!");
                trapFile.Write(index);
            }
        }

        ITypeSignature ISignatureTypeProvider<ITypeSignature, object>.GetGenericMethodParameter(object genericContext, int index) =>
            new GenericMethodParameter(genericContext, index);

        ITypeSignature ISignatureTypeProvider<ITypeSignature, object>.GetGenericTypeParameter(object genericContext, int index) =>
            new GenericTypeParameter(index);

        private class Modified : ITypeSignature
        {
            private readonly ITypeSignature unmodifiedType;

            public Modified(ITypeSignature unmodifiedType)
            {
                this.unmodifiedType = unmodifiedType;
            }

            public void WriteId(TextWriter trapFile, GenericContext gc)
            {
                unmodifiedType.WriteId(trapFile, gc);
            }
        }

        ITypeSignature ISignatureTypeProvider<ITypeSignature, object>.GetModifiedType(ITypeSignature modifier, ITypeSignature unmodifiedType, bool isRequired)
        {
            return new Modified(unmodifiedType);
        }

        private class Pinned : ITypeSignature
        {
            private readonly ITypeSignature elementType;

            public Pinned(ITypeSignature elementType)
            {
                this.elementType = elementType;
            }

            public void WriteId(TextWriter trapFile, GenericContext gc)
            {
                trapFile.Write("pinned ");
                elementType.WriteId(trapFile, gc);
            }
        }

        ITypeSignature ISignatureTypeProvider<ITypeSignature, object>.GetPinnedType(ITypeSignature elementType)
        {
            return new Pinned(elementType);
        }

        private class PointerType : ITypeSignature
        {
            private readonly ITypeSignature elementType;

            public PointerType(ITypeSignature elementType)
            {
                this.elementType = elementType;
            }

            public void WriteId(TextWriter trapFile, GenericContext gc)
            {
                elementType.WriteId(trapFile, gc);
                trapFile.Write('*');
            }
        }

        ITypeSignature IConstructedTypeProvider<ITypeSignature>.GetPointerType(ITypeSignature elementType)
        {
            return new PointerType(elementType);
        }

        private class Primitive : ITypeSignature
        {
            private readonly PrimitiveTypeCode typeCode;

            public Primitive(PrimitiveTypeCode typeCode)
            {
                this.typeCode = typeCode;
            }

            public void WriteId(TextWriter trapFile, GenericContext gc)
            {
                trapFile.Write(typeCode.Id());
            }
        }

        ITypeSignature ISimpleTypeProvider<ITypeSignature>.GetPrimitiveType(PrimitiveTypeCode typeCode)
        {
            return new Primitive(typeCode);
        }

        private class SzArrayType : ITypeSignature
        {
            private readonly ITypeSignature elementType;

            public SzArrayType(ITypeSignature elementType)
            {
                this.elementType = elementType;
            }

            public void WriteId(TextWriter trapFile, GenericContext gc)
            {
                elementType.WriteId(trapFile, gc);
                trapFile.Write("[]");
            }
        }

        ITypeSignature ISZArrayTypeProvider<ITypeSignature>.GetSZArrayType(ITypeSignature elementType)
        {
            return new SzArrayType(elementType);
        }

        private class TypeDefinition : ITypeSignature
        {
            private readonly TypeDefinitionHandle handle;

            public TypeDefinition(TypeDefinitionHandle handle)
            {
                this.handle = handle;
            }

            public void WriteId(TextWriter trapFile, GenericContext gc)
            {
                var type = (Type)gc.Cx.Create(handle);
                type.WriteId(trapFile);
            }
        }

        ITypeSignature ISimpleTypeProvider<ITypeSignature>.GetTypeFromDefinition(MetadataReader reader, TypeDefinitionHandle handle, byte rawTypeKind)
        {
            return new TypeDefinition(handle);
        }

        private class TypeReference : ITypeSignature
        {
            private readonly TypeReferenceHandle handle;

            public TypeReference(TypeReferenceHandle handle)
            {
                this.handle = handle;
            }

            public void WriteId(TextWriter trapFile, GenericContext gc)
            {
                var type = (Type)gc.Cx.Create(handle);
                type.WriteId(trapFile);
            }
        }

        ITypeSignature ISimpleTypeProvider<ITypeSignature>.GetTypeFromReference(MetadataReader reader, TypeReferenceHandle handle, byte rawTypeKind)
        {
            return new TypeReference(handle);
        }

        ITypeSignature ISignatureTypeProvider<ITypeSignature, object>.GetTypeFromSpecification(MetadataReader reader, object genericContext, TypeSpecificationHandle handle, byte rawTypeKind)
        {
            var ts = reader.GetTypeSpecification(handle);
            return ts.DecodeSignature(this, genericContext);
        }
    }


    /// <summary>
    /// Decodes a type signature and produces a Type, for use by DecodeSignature() and friends.
    /// </summary>
    public class TypeSignatureDecoder : ISignatureTypeProvider<Type, GenericContext>
    {
        private readonly Context cx;

        public TypeSignatureDecoder(Context cx)
        {
            this.cx = cx;
        }

        Type IConstructedTypeProvider<Type>.GetArrayType(Type elementType, ArrayShape shape) =>
            cx.Populate(new ArrayType(cx, elementType, shape.Rank));

        Type IConstructedTypeProvider<Type>.GetByReferenceType(Type elementType) =>
            elementType;  // ??

        Type ISignatureTypeProvider<Type, GenericContext>.GetFunctionPointerType(MethodSignature<Type> signature) =>
            cx.ErrorType; // Don't know what to do !!

        Type IConstructedTypeProvider<Type>.GetGenericInstantiation(Type genericType, ImmutableArray<Type> typeArguments) =>
            genericType.Construct(typeArguments);

        Type ISignatureTypeProvider<Type, GenericContext>.GetGenericMethodParameter(GenericContext genericContext, int index) =>
            genericContext.GetGenericMethodParameter(index);

        Type ISignatureTypeProvider<Type, GenericContext>.GetGenericTypeParameter(GenericContext genericContext, int index) =>
            genericContext.GetGenericTypeParameter(index);

        Type ISignatureTypeProvider<Type, GenericContext>.GetModifiedType(Type modifier, Type unmodifiedType, bool isRequired) =>
            unmodifiedType; // !! Not implemented properly

        Type ISignatureTypeProvider<Type, GenericContext>.GetPinnedType(Type elementType) =>
            cx.Populate(new PointerType(cx, elementType));

        Type IConstructedTypeProvider<Type>.GetPointerType(Type elementType) =>
            cx.Populate(new PointerType(cx, elementType));

        Type ISimpleTypeProvider<Type>.GetPrimitiveType(PrimitiveTypeCode typeCode) => cx.Create(typeCode);

        Type ISZArrayTypeProvider<Type>.GetSZArrayType(Type elementType) =>
            cx.Populate(new ArrayType(cx, elementType));

        Type ISimpleTypeProvider<Type>.GetTypeFromDefinition(MetadataReader reader, TypeDefinitionHandle handle, byte rawTypeKind) =>
            (Type)cx.Create(handle);

        Type ISimpleTypeProvider<Type>.GetTypeFromReference(MetadataReader reader, TypeReferenceHandle handle, byte rawTypeKind) =>
            (Type)cx.Create(handle);

        Type ISignatureTypeProvider<Type, GenericContext>.GetTypeFromSpecification(MetadataReader reader, GenericContext genericContext, TypeSpecificationHandle handle, byte rawTypeKind) =>
            throw new NotImplementedException();
    }
}
