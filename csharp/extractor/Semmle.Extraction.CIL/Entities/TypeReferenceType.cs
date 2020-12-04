using System;
using Microsoft.CodeAnalysis;
using System.Reflection.Metadata;
using System.Collections.Immutable;
using System.Linq;
using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A type reference, to a type in a referenced assembly.
    /// </summary>
    public sealed class TypeReferenceType : Type
    {
        private readonly TypeReferenceHandle handle;
        private readonly TypeReference tr;
        private readonly Lazy<TypeTypeParameter[]> typeParams;
        private readonly NamedTypeIdWriter idWriter;

        public TypeReferenceType(Context cx, TypeReferenceHandle handle) : base(cx)
        {
            this.idWriter = new NamedTypeIdWriter(this);
            this.handle = handle;
            this.tr = cx.MdReader.GetTypeReference(handle);
            this.typeParams = new Lazy<TypeTypeParameter[]>(GenericsHelper.MakeTypeParameters(this, ThisTypeParameterCount));
        }

        public override bool Equals(object? obj)
        {
            return obj is TypeReferenceType t && handle.Equals(t.handle);
        }

        public override int GetHashCode()
        {
            return handle.GetHashCode();
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

        public override string Name => GenericsHelper.GetNonGenericName(tr.Name, Cx.MdReader);

        public override Namespace ContainingNamespace => Cx.CreateNamespace(tr.Namespace);

        public override Type? ContainingType
        {
            get
            {
                return tr.ResolutionScope.Kind == HandleKind.TypeReference
                    ? (Type)Cx.Create((TypeReferenceHandle)tr.ResolutionScope)
                    : null;
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
                    trapFile.Write(Entities.Type.AssemblyTypeNameSeparator);
                    break;
                default:
                    Cx.WriteAssemblyPrefix(trapFile);
                    break;
            }
        }

        public override int ThisTypeParameterCount => GenericsHelper.GetGenericTypeParameterCount(tr.Name, Cx.MdReader);

        public override IEnumerable<Type> TypeParameters => GenericsHelper.GetAllTypeParameters(ContainingType, typeParams!.Value);

        public override IEnumerable<Type> ThisGenericArguments => typeParams.Value;

        public override void WriteId(TextWriter trapFile, bool inContext)
        {
            idWriter.WriteId(trapFile, inContext);
        }

        public override Type Construct(IEnumerable<Type> typeArguments)
        {
            if (TotalTypeParametersCount != typeArguments.Count())
                throw new InternalError("Mismatched type arguments");

            return Cx.Populate(new ConstructedType(Cx, this, typeArguments));
        }
    }
}
