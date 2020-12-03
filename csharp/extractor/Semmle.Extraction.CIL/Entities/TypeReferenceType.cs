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
            var newTypeParams = new TypeTypeParameter[ThisTypeParameterCount];
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

        public override Namespace ContainingNamespace => Cx.CreateNamespace(tr.Namespace);

        public override int ThisTypeParameterCount
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
                    trapFile.Write("::");
                    break;
                default:
                    Cx.WriteAssemblyPrefix(trapFile);
                    break;
            }
        }

        public override IEnumerable<Type> TypeParameters => typeParams.Value;

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
