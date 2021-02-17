using System;
using System.Reflection.Metadata;
using System.Collections.Immutable;
using System.Linq;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// Decodes a type signature and produces a Type, for use by DecodeSignature() and friends.
    /// </summary>
    internal class TypeSignatureDecoder : ISignatureTypeProvider<Type, IGenericContext>
    {
        private readonly Context cx;

        public TypeSignatureDecoder(Context cx)
        {
            this.cx = cx;
        }

        Type IConstructedTypeProvider<Type>.GetArrayType(Type elementType, ArrayShape shape) =>
            cx.Populate(new ArrayType(cx, elementType, shape.Rank));

        Type IConstructedTypeProvider<Type>.GetByReferenceType(Type elementType) =>
            new ByRefType(cx, elementType);

        Type ISignatureTypeProvider<Type, IGenericContext>.GetFunctionPointerType(MethodSignature<Type> signature) =>
            cx.Populate(new FunctionPointerType(cx, signature));

        Type IConstructedTypeProvider<Type>.GetGenericInstantiation(Type genericType, ImmutableArray<Type> typeArguments) =>
            genericType.Construct(typeArguments);

        Type ISignatureTypeProvider<Type, IGenericContext>.GetGenericMethodParameter(IGenericContext genericContext, int index) =>
            genericContext.MethodParameters.ElementAt(index);

        Type ISignatureTypeProvider<Type, IGenericContext>.GetGenericTypeParameter(IGenericContext genericContext, int index) =>
            genericContext.TypeParameters.ElementAt(index);

        Type ISignatureTypeProvider<Type, IGenericContext>.GetModifiedType(Type modifier, Type unmodifiedType, bool isRequired) =>
            new ModifiedType(cx, unmodifiedType, modifier, isRequired);

        Type ISignatureTypeProvider<Type, IGenericContext>.GetPinnedType(Type elementType) => elementType;

        Type IConstructedTypeProvider<Type>.GetPointerType(Type elementType) =>
            cx.Populate(new PointerType(cx, elementType));

        Type ISimpleTypeProvider<Type>.GetPrimitiveType(PrimitiveTypeCode typeCode) => cx.Create(typeCode);

        Type ISZArrayTypeProvider<Type>.GetSZArrayType(Type elementType) =>
            cx.Populate(new ArrayType(cx, elementType));

        Type ISimpleTypeProvider<Type>.GetTypeFromDefinition(MetadataReader reader, TypeDefinitionHandle handle, byte rawTypeKind) =>
            (Type)cx.Create(handle);

        Type ISimpleTypeProvider<Type>.GetTypeFromReference(MetadataReader reader, TypeReferenceHandle handle, byte rawTypeKind) =>
            (Type)cx.Create(handle);

        Type ISignatureTypeProvider<Type, IGenericContext>.GetTypeFromSpecification(MetadataReader reader, IGenericContext genericContext, TypeSpecificationHandle handle, byte rawTypeKind) =>
            throw new NotImplementedException();
    }
}
