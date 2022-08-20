#include "swift/extractor/visitors/TypeVisitor.h"

namespace codeql {
void TypeVisitor::visit(swift::TypeBase* type) {
  TypeVisitorBase<TypeVisitor>::visit(type);
  auto label = dispatcher_.fetchLabel(type);
  auto canonical = type->getCanonicalType().getPointer();
  auto canonicalLabel = (canonical == type) ? label : dispatcher_.fetchLabel(canonical);
  dispatcher_.emit(TypesTrap{label, type->getString(), canonicalLabel});
}

codeql::TypeRepr TypeVisitor::translateTypeRepr(const swift::TypeRepr& typeRepr, swift::Type type) {
  auto entry = dispatcher_.createEntry(typeRepr);
  entry.type = dispatcher_.fetchOptionalLabel(type);
  return entry;
}

void TypeVisitor::visitProtocolType(swift::ProtocolType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  dispatcher_.emit(ProtocolTypesTrap{label});
  emitAnyGenericType(type, label);
}

void TypeVisitor::visitEnumType(swift::EnumType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  dispatcher_.emit(EnumTypesTrap{label});
  emitAnyGenericType(type, label);
}

void TypeVisitor::visitStructType(swift::StructType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  dispatcher_.emit(StructTypesTrap{label});
  emitAnyGenericType(type, label);
}

void TypeVisitor::visitClassType(swift::ClassType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  dispatcher_.emit(ClassTypesTrap{label});
  emitAnyGenericType(type, label);
}

void TypeVisitor::visitFunctionType(swift::FunctionType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  dispatcher_.emit(FunctionTypesTrap{label});
  emitAnyFunctionType(type, label);
}

void TypeVisitor::visitTupleType(swift::TupleType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  dispatcher_.emit(TupleTypesTrap{label});
  auto i = 0u;
  for (const auto& e : type->getElements()) {
    auto typeTag = dispatcher_.fetchLabel(e.getType());
    dispatcher_.emit(TupleTypeTypesTrap{label, i, typeTag});
    if (e.hasName()) {
      dispatcher_.emit(TupleTypeNamesTrap{label, i, e.getName().str().str()});
    }
    ++i;
  }
}

void TypeVisitor::visitBoundGenericEnumType(swift::BoundGenericEnumType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  dispatcher_.emit(BoundGenericEnumTypesTrap{label});
  emitBoundGenericType(type, label);
}

void TypeVisitor::visitMetatypeType(swift::MetatypeType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  dispatcher_.emit(MetatypeTypesTrap{label});
}

void TypeVisitor::visitExistentialMetatypeType(swift::ExistentialMetatypeType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  dispatcher_.emit(ExistentialMetatypeTypesTrap{label});
}

void TypeVisitor::visitBoundGenericStructType(swift::BoundGenericStructType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  dispatcher_.emit(BoundGenericStructTypesTrap{label});
  emitBoundGenericType(type, label);
}

void TypeVisitor::visitTypeAliasType(swift::TypeAliasType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  assert(type->getDecl() && "expect TypeAliasType to have Decl");
  dispatcher_.emit(TypeAliasTypesTrap{label, dispatcher_.fetchLabel(type->getDecl())});
}

void TypeVisitor::visitBuiltinIntegerLiteralType(swift::BuiltinIntegerLiteralType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  dispatcher_.emit(BuiltinIntegerLiteralTypesTrap{label});
}

void TypeVisitor::visitBuiltinFloatType(swift::BuiltinFloatType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  dispatcher_.emit(BuiltinFloatTypesTrap{label});
}

void TypeVisitor::visitBuiltinIntegerType(swift::BuiltinIntegerType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  auto width = type->getWidth();
  if (width.isFixedWidth()) {
    dispatcher_.emit(BuiltinIntegerTypeWidthsTrap{label, width.getFixedWidth()});
  }
  dispatcher_.emit(BuiltinIntegerTypesTrap{label});
}

void TypeVisitor::visitBoundGenericClassType(swift::BoundGenericClassType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  dispatcher_.emit(BoundGenericClassTypesTrap{label});
  emitBoundGenericType(type, label);
}

void TypeVisitor::visitDependentMemberType(swift::DependentMemberType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  assert(type->getBase() && "expect TypeAliasType to have Base");
  assert(type->getAssocType() && "expect TypeAliasType to have AssocType");
  auto baseLabel = dispatcher_.fetchLabel(type->getBase());
  auto assocTypeDeclLabel = dispatcher_.fetchLabel(type->getAssocType());
  dispatcher_.emit(DependentMemberTypesTrap{label, baseLabel, assocTypeDeclLabel});
}

void TypeVisitor::visitParenType(swift::ParenType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  assert(type->getUnderlyingType() && "expect ParenType to have UnderlyingType");
  auto typeLabel = dispatcher_.fetchLabel(type->getUnderlyingType());
  dispatcher_.emit(ParenTypesTrap{label, typeLabel});
}

codeql::OptionalType TypeVisitor::translateOptionalType(const swift::OptionalType& type) {
  auto entry = createTypeEntry(type);
  fillUnarySyntaxSugarType(type, entry);
  return entry;
}

codeql::ArraySliceType TypeVisitor::translateArraySliceType(const swift::ArraySliceType& type) {
  auto entry = createTypeEntry(type);
  fillUnarySyntaxSugarType(type, entry);
  return entry;
}

void TypeVisitor::visitDictionaryType(swift::DictionaryType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  auto keyLabel = dispatcher_.fetchLabel(type->getKeyType());
  auto valueLabel = dispatcher_.fetchLabel(type->getValueType());
  dispatcher_.emit(DictionaryTypesTrap{label, keyLabel, valueLabel});
}

void TypeVisitor::visitGenericFunctionType(swift::GenericFunctionType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  dispatcher_.emit(GenericFunctionTypesTrap{label});
  emitAnyFunctionType(type, label);
  auto i = 0u;
  for (auto p : type->getGenericParams()) {
    dispatcher_.emit(GenericFunctionTypeGenericParamsTrap{label, i++, dispatcher_.fetchLabel(p)});
  }
}

void TypeVisitor::visitGenericTypeParamType(swift::GenericTypeParamType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  dispatcher_.emit(GenericTypeParamTypesTrap{label});
}

void TypeVisitor::visitLValueType(swift::LValueType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  assert(type->getObjectType() && "expect LValueType to have ObjectType");
  dispatcher_.emit(LValueTypesTrap{label, dispatcher_.fetchLabel(type->getObjectType())});
}

codeql::PrimaryArchetypeType TypeVisitor::translatePrimaryArchetypeType(
    const swift::PrimaryArchetypeType& type) {
  auto entry = createTypeEntry(type);
  fillArchetypeType(type, entry);
  return entry;
}

void TypeVisitor::visitUnboundGenericType(swift::UnboundGenericType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  dispatcher_.emit(UnboundGenericTypesTrap{label});
  emitAnyGenericType(type, label);
}

void TypeVisitor::visitBoundGenericType(swift::BoundGenericType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  emitBoundGenericType(type, label);
}

void TypeVisitor::fillUnarySyntaxSugarType(const swift::UnarySyntaxSugarType& type,
                                           codeql::UnarySyntaxSugarType& entry) {
  assert(type.getBaseType() && "expect UnarySyntaxSugarType to have BaseType");
  entry.base_type = dispatcher_.fetchLabel(type.getBaseType());
}

void TypeVisitor::emitAnyFunctionType(const swift::AnyFunctionType* type,
                                      TrapLabel<AnyFunctionTypeTag> label) {
  assert(type->getResult() && "expect FunctionType to have Result");
  dispatcher_.emit(AnyFunctionTypesTrap{label, dispatcher_.fetchLabel(type->getResult())});
  auto i = 0u;
  for (const auto& p : type->getParams()) {
    assert(p.getPlainType() && "expect Param to have PlainType");
    dispatcher_.emit(
        AnyFunctionTypeParamTypesTrap{label, i, dispatcher_.fetchLabel(p.getPlainType())});
    if (p.hasLabel()) {
      dispatcher_.emit(AnyFunctionTypeParamLabelsTrap{label, i, p.getLabel().str().str()});
    }
    ++i;
  }

  if (type->isThrowing()) {
    dispatcher_.emit(AnyFunctionTypeIsThrowingTrap{label});
  }

  if (type->isAsync()) {
    dispatcher_.emit(AnyFunctionTypeIsAsyncTrap{label});
  }
}

void TypeVisitor::emitBoundGenericType(swift::BoundGenericType* type,
                                       TrapLabel<BoundGenericTypeTag> label) {
  auto i = 0u;
  for (const auto& t : type->getGenericArgs()) {
    dispatcher_.emit(BoundGenericTypeArgTypesTrap{label, i++, dispatcher_.fetchLabel(t)});
  }
  emitAnyGenericType(type, label);
}

void TypeVisitor::emitAnyGenericType(swift::AnyGenericType* type,
                                     TrapLabel<AnyGenericTypeTag> label) {
  assert(type->getDecl() && "expect AnyGenericType to have Decl");
  dispatcher_.emit(AnyGenericTypesTrap{label, dispatcher_.fetchLabel(type->getDecl())});
  if (auto parent = type->getParent()) {
    dispatcher_.emit(AnyGenericTypeParentsTrap{label, dispatcher_.fetchLabel(parent)});
  }
}

codeql::NestedArchetypeType TypeVisitor::translateNestedArchetypeType(
    const swift::NestedArchetypeType& type) {
  auto entry = createTypeEntry(type);
  entry.parent = dispatcher_.fetchLabel(type.getParent());
  entry.associated_type_declaration = dispatcher_.fetchLabel(type.getAssocType());
  fillArchetypeType(type, entry);
  return entry;
}

void TypeVisitor::fillType(const swift::TypeBase& type, codeql::Type& entry) {
  entry.name = type.getString();
  entry.canonical_type = dispatcher_.fetchLabel(type.getCanonicalType());
}

void TypeVisitor::fillArchetypeType(const swift::ArchetypeType& type, ArchetypeType& entry) {
  entry.interface_type = dispatcher_.fetchLabel(type.getInterfaceType());
  entry.protocols = dispatcher_.fetchRepeatedLabels(type.getConformsTo());
  entry.superclass = dispatcher_.fetchOptionalLabel(type.getSuperclass());
}

codeql::ExistentialType TypeVisitor::translateExistentialType(const swift::ExistentialType& type) {
  auto entry = createTypeEntry(type);
  entry.constraint = dispatcher_.fetchLabel(type.getConstraintType());
  return entry;
}

codeql::DynamicSelfType TypeVisitor::translateDynamicSelfType(const swift::DynamicSelfType& type) {
  auto entry = createTypeEntry(type);
  entry.static_self_type = dispatcher_.fetchLabel(type.getSelfType());
  return entry;
}

codeql::VariadicSequenceType TypeVisitor::translateVariadicSequenceType(
    const swift::VariadicSequenceType& type) {
  auto entry = createTypeEntry(type);
  fillUnarySyntaxSugarType(type, entry);
  return entry;
}

codeql::InOutType TypeVisitor::translateInOutType(const swift::InOutType& type) {
  auto entry = createTypeEntry(type);
  entry.object_type = dispatcher_.fetchLabel(type.getObjectType());
  return entry;
}

codeql::UnmanagedStorageType TypeVisitor::translateUnmanagedStorageType(
    const swift::UnmanagedStorageType& type) {
  codeql::UnmanagedStorageType entry{dispatcher_.assignNewLabel(type)};
  fillReferenceStorageType(type, entry);
  return entry;
}

codeql::UnownedStorageType TypeVisitor::translateUnownedStorageType(
    const swift::UnownedStorageType& type) {
  codeql::UnownedStorageType entry{dispatcher_.assignNewLabel(type)};
  fillReferenceStorageType(type, entry);
  return entry;
}

codeql::WeakStorageType TypeVisitor::translateWeakStorageType(const swift::WeakStorageType& type) {
  codeql::WeakStorageType entry{dispatcher_.assignNewLabel(type)};
  fillReferenceStorageType(type, entry);
  return entry;
}

void TypeVisitor::fillReferenceStorageType(const swift::ReferenceStorageType& type,
                                           codeql::ReferenceStorageType& entry) {
  entry.referent_type = dispatcher_.fetchLabel(type.getReferentType());
  fillType(type, entry);
}

codeql::ProtocolCompositionType TypeVisitor::translateProtocolCompositionType(
    const swift::ProtocolCompositionType& type) {
  auto entry = createTypeEntry(type);
  entry.members = dispatcher_.fetchRepeatedLabels(type.getMembers());
  return entry;
}

codeql::BuiltinIntegerLiteralType TypeVisitor::translateBuiltinIntegerLiteralType(
    const swift::BuiltinIntegerLiteralType& type) {
  return createTypeEntry(type);
}

codeql::BuiltinIntegerType TypeVisitor::translateBuiltinIntegerType(
    const swift::BuiltinIntegerType& type) {
  auto entry = createTypeEntry(type);
  if (type.isFixedWidth()) {
    entry.width = type.getFixedWidth();
  }
  return entry;
}

codeql::BuiltinBridgeObjectType TypeVisitor::translateBuiltinBridgeObjectType(
    const swift::BuiltinBridgeObjectType& type) {
  return createTypeEntry(type);
}

codeql::BuiltinDefaultActorStorageType TypeVisitor::translateBuiltinDefaultActorStorageType(
    const swift::BuiltinDefaultActorStorageType& type) {
  return createTypeEntry(type);
}

codeql::BuiltinExecutorType TypeVisitor::translateBuiltinExecutorType(
    const swift::BuiltinExecutorType& type) {
  return createTypeEntry(type);
}

codeql::BuiltinFloatType TypeVisitor::translateBuiltinFloatType(
    const swift::BuiltinFloatType& type) {
  return createTypeEntry(type);
}

codeql::BuiltinJobType TypeVisitor::translateBuiltinJobType(const swift::BuiltinJobType& type) {
  return createTypeEntry(type);
}

codeql::BuiltinNativeObjectType TypeVisitor::translateBuiltinNativeObjectType(
    const swift::BuiltinNativeObjectType& type) {
  return createTypeEntry(type);
}

codeql::BuiltinRawPointerType TypeVisitor::translateBuiltinRawPointerType(
    const swift::BuiltinRawPointerType& type) {
  return createTypeEntry(type);
}

codeql::BuiltinRawUnsafeContinuationType TypeVisitor::translateBuiltinRawUnsafeContinuationType(
    const swift::BuiltinRawUnsafeContinuationType& type) {
  return createTypeEntry(type);
}

codeql::BuiltinUnsafeValueBufferType TypeVisitor::translateBuiltinUnsafeValueBufferType(
    const swift::BuiltinUnsafeValueBufferType& type) {
  return createTypeEntry(type);
}

codeql::BuiltinVectorType TypeVisitor::translateBuiltinVectorType(
    const swift::BuiltinVectorType& type) {
  return createTypeEntry(type);
}

codeql::OpenedArchetypeType TypeVisitor::translateOpenedArchetypeType(
    const swift::OpenedArchetypeType& type) {
  auto entry = createTypeEntry(type);
  fillArchetypeType(type, entry);
  return entry;
}

codeql::ModuleType TypeVisitor::translateModuleType(const swift::ModuleType& type) {
  auto key = type.getModule()->getRealName().str().str();
  if (type.getModule()->isNonSwiftModule()) {
    key += "|clang";
  }
  auto entry = createTypeEntry(type, key);
  entry.module = dispatcher_.fetchLabel(type.getModule());
  return entry;
}
}  // namespace codeql
