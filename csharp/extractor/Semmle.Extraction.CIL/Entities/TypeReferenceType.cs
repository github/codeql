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
}
