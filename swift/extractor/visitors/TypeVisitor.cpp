#include "swift/extractor/visitors/TypeVisitor.h"
namespace codeql {
void TypeVisitor::visit(swift::TypeBase* type) {
  TypeVisitorBase<TypeVisitor>::visit(type);
  auto label = dispatcher_.fetchLabel(type);
  auto canonical = type->getCanonicalType().getPointer();
  auto canonicalLabel = (canonical == type) ? label : dispatcher_.fetchLabel(canonical);
  dispatcher_.emit(TypesTrap{label, type->getString(), canonicalLabel});
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
  codeql::OptionalType entry{dispatcher_.assignNewLabel(type)};
  fillUnarySyntaxSugarType(type, entry);
  return entry;
}

codeql::ArraySliceType TypeVisitor::translateArraySliceType(const swift::ArraySliceType& type) {
  codeql::ArraySliceType entry{dispatcher_.assignNewLabel(type)};
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
  dispatcher_.emit(GenericTypeParamTypesTrap{label, type->getName().str().str()});
}

void TypeVisitor::visitLValueType(swift::LValueType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  assert(type->getObjectType() && "expect LValueType to have ObjectType");
  dispatcher_.emit(LValueTypesTrap{label, dispatcher_.fetchLabel(type->getObjectType())});
}

codeql::PrimaryArchetypeType TypeVisitor::translatePrimaryArchetypeType(
    const swift::PrimaryArchetypeType& type) {
  PrimaryArchetypeType entry{dispatcher_.assignNewLabel(type)};
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
  fillType(type, entry);
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
  codeql::NestedArchetypeType entry{dispatcher_.assignNewLabel(type)};
  entry.parent = dispatcher_.fetchLabel(type.getParent());
  entry.associated_type_declaration = dispatcher_.fetchLabel(type.getAssocType());
  fillArchetypeType(type, entry);
  return entry;
}

void TypeVisitor::fillType(const swift::TypeBase& type, codeql::Type& entry) {
  entry.diagnostics_name = type.getString();
  entry.canonical_type = dispatcher_.fetchLabel(type.getCanonicalType());
}

void TypeVisitor::fillArchetypeType(const swift::ArchetypeType& type, ArchetypeType& entry) {
  entry.interface_type = dispatcher_.fetchLabel(type.getInterfaceType());
  entry.name = type.getName().str().str();
  entry.protocols = dispatcher_.fetchRepeatedLabels(type.getConformsTo());
  entry.superclass = dispatcher_.fetchOptionalLabel(type.getSuperclass());
  fillType(type, entry);
}

codeql::ExistentialType TypeVisitor::translateExistentialType(const swift::ExistentialType& type) {
  codeql::ExistentialType entry{dispatcher_.assignNewLabel(type)};
  entry.constraint = dispatcher_.fetchLabel(type.getConstraintType());
  fillType(type, entry);
  return entry;
}

codeql::DynamicSelfType TypeVisitor::translateDynamicSelfType(const swift::DynamicSelfType& type) {
  codeql::DynamicSelfType entry{dispatcher_.assignNewLabel(type)};
  entry.static_self_type = dispatcher_.fetchLabel(type.getSelfType());
  fillType(type, entry);
  return entry;
}

codeql::VariadicSequenceType TypeVisitor::translateVariadicSequenceType(
    const swift::VariadicSequenceType& type) {
  codeql::VariadicSequenceType entry{dispatcher_.assignNewLabel(type)};
  fillUnarySyntaxSugarType(type, entry);
  return entry;
}

codeql::InOutType TypeVisitor::translateInOutType(const swift::InOutType& type) {
  codeql::InOutType entry{dispatcher_.assignNewLabel(type)};
  entry.object_type = dispatcher_.fetchLabel(type.getObjectType());
  fillType(type, entry);
  return entry;
}

}  // namespace codeql
