using System;
using Microsoft.CodeAnalysis;
using System.Reflection.Metadata;
using System.Collections.Immutable;
using System.Linq;
using System.Collections.Generic;
using System.Reflection;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
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

                    if (IsSystemEnum(td.BaseType) &&
                        GetUnderlyingEnumType() is var underlying &&
                        underlying.HasValue)
                    {
                        var underlyingType = Cx.Create(underlying.Value);
                        yield return underlyingType;
                        yield return Tuples.cil_enum_underlying_type(this, underlyingType);
                    }
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

        private bool IsSystemEnum(EntityHandle baseType)
        {
            return baseType.Kind switch
            {
                HandleKind.TypeReference => IsSystemEnum((TypeReferenceHandle)baseType),
                HandleKind.TypeDefinition => IsSystemEnum((TypeDefinitionHandle)baseType),
                _ => false,
            };
        }

        private bool IsSystemEnum(TypeReferenceHandle baseType)
        {
            var baseTypeReference = Cx.MdReader.GetTypeReference(baseType);

            return IsSystemEnum(baseTypeReference.Name, baseTypeReference.Namespace);
        }

        private bool IsSystemEnum(TypeDefinitionHandle baseType)
        {
            var baseTypeDefinition = Cx.MdReader.GetTypeDefinition(baseType);

            return IsSystemEnum(baseTypeDefinition.Name, baseTypeDefinition.Namespace);
        }

        private bool IsSystemEnum(StringHandle typeName, StringHandle namespaceName)
        {
            return Cx.MdReader.StringComparer.Equals(typeName, "Enum") &&
                !namespaceName.IsNil &&
                Cx.MdReader.StringComparer.Equals(namespaceName, "System");
        }

        internal PrimitiveTypeCode? GetUnderlyingEnumType()
        {
            foreach (var handle in td.GetFields())
            {
                var field = Cx.MdReader.GetFieldDefinition(handle);
                if ((field.Attributes & FieldAttributes.Static) != 0)
                {
                    continue;
                }

                var blob = Cx.MdReader.GetBlobReader(field.Signature);
                if (blob.ReadSignatureHeader().Kind != SignatureKind.Field)
                {
                    break;
                }

                return (PrimitiveTypeCode)blob.ReadByte();
            }

            return null;
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
}
