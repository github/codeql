using System;
using System.Reflection.Metadata;
using System.Collections.Immutable;

namespace Semmle.Extraction.CIL.Entities
{
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
            new ModifiedType(cx, unmodifiedType, modifier, isRequired);

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
