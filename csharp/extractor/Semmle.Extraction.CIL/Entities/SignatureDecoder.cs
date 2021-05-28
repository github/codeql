using System.Reflection.Metadata;
using System.Collections.Immutable;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
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

            public void WriteId(EscapingTextWriter trapFile, IGenericContext gc)
            {
                elementType.WriteId(trapFile, gc);
                trapFile.Write('[');
                for (var i = 1; i < shape.Rank; ++i)
                {
                    trapFile.Write(',');
                }
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

            public void WriteId(EscapingTextWriter trapFile, IGenericContext gc)
            {
                elementType.WriteId(trapFile, gc);
                trapFile.Write('&');
            }
        }

        private struct FnPtr : ITypeSignature
        {
            private readonly MethodSignature<ITypeSignature> signature;

            public FnPtr(MethodSignature<ITypeSignature> signature)
            {
                this.signature = signature;
            }

            public void WriteId(EscapingTextWriter trapFile, IGenericContext gc)
            {
                FunctionPointerType.WriteName(
                    trapFile.Write,
                    t => t.WriteId(trapFile, gc),
                    signature
                );
            }
        }

        ITypeSignature IConstructedTypeProvider<ITypeSignature>.GetArrayType(ITypeSignature elementType, ArrayShape shape) =>
            new Array(elementType, shape);

        ITypeSignature IConstructedTypeProvider<ITypeSignature>.GetByReferenceType(ITypeSignature elementType) =>
            new ByRef(elementType);

        ITypeSignature ISignatureTypeProvider<ITypeSignature, object>.GetFunctionPointerType(MethodSignature<ITypeSignature> signature) =>
            new FnPtr(signature);

        private class Instantiation : ITypeSignature
        {
            private readonly ITypeSignature genericType;
            private readonly ImmutableArray<ITypeSignature> typeArguments;

            public Instantiation(ITypeSignature genericType, ImmutableArray<ITypeSignature> typeArguments)
            {
                this.genericType = genericType;
                this.typeArguments = typeArguments;
            }

            public void WriteId(EscapingTextWriter trapFile, IGenericContext gc)
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

            public void WriteId(EscapingTextWriter trapFile, IGenericContext outerGc)
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

            public void WriteId(EscapingTextWriter trapFile, IGenericContext gc)
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
            private readonly ITypeSignature modifier;
            private readonly bool isRequired;

            public Modified(ITypeSignature unmodifiedType, ITypeSignature modifier, bool isRequired)
            {
                this.unmodifiedType = unmodifiedType;
                this.modifier = modifier;
                this.isRequired = isRequired;
            }

            public void WriteId(EscapingTextWriter trapFile, IGenericContext gc)
            {
                unmodifiedType.WriteId(trapFile, gc);
                trapFile.Write(isRequired ? " modreq(" : " modopt(");
                modifier.WriteId(trapFile, gc);
                trapFile.Write(")");
            }
        }

        ITypeSignature ISignatureTypeProvider<ITypeSignature, object>.GetModifiedType(ITypeSignature modifier, ITypeSignature unmodifiedType, bool isRequired)
        {
            return new Modified(unmodifiedType, modifier, isRequired);
        }

        ITypeSignature ISignatureTypeProvider<ITypeSignature, object>.GetPinnedType(ITypeSignature elementType)
        {
            return elementType;
        }

        private class PointerType : ITypeSignature
        {
            private readonly ITypeSignature elementType;

            public PointerType(ITypeSignature elementType)
            {
                this.elementType = elementType;
            }

            public void WriteId(EscapingTextWriter trapFile, IGenericContext gc)
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

            public void WriteId(EscapingTextWriter trapFile, IGenericContext gc)
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

            public void WriteId(EscapingTextWriter trapFile, IGenericContext gc)
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

            public void WriteId(EscapingTextWriter trapFile, IGenericContext gc)
            {
                var type = (Type)gc.Context.Create(handle);
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

            public void WriteId(EscapingTextWriter trapFile, IGenericContext gc)
            {
                var type = (Type)gc.Context.Create(handle);
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
}
