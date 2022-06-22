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

void TypeVisitor::visitUnarySyntaxSugarType(swift::UnarySyntaxSugarType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  emitUnarySyntaxSugarType(type, label);
}

void TypeVisitor::visitOptionalType(swift::OptionalType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  dispatcher_.emit(OptionalTypesTrap{label});
  emitUnarySyntaxSugarType(type, label);
}

void TypeVisitor::visitArraySliceType(swift::ArraySliceType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  dispatcher_.emit(ArraySliceTypesTrap{label});
  emitUnarySyntaxSugarType(type, label);
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

void TypeVisitor::visitPrimaryArchetypeType(swift::PrimaryArchetypeType* type) {
  auto label = dispatcher_.assignNewLabel(type);
  assert(type->getInterfaceType() && "expect PrimaryArchetypeType to have InterfaceType");
  dispatcher_.emit(
      PrimaryArchetypeTypesTrap{label, dispatcher_.fetchLabel(type->getInterfaceType())});
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

void TypeVisitor::emitUnarySyntaxSugarType(const swift::UnarySyntaxSugarType* type,
                                           TrapLabel<UnarySyntaxSugarTypeTag> label) {
  assert(type->getBaseType() && "expect UnarySyntaxSugarType to have BaseType");
  dispatcher_.emit(UnarySyntaxSugarTypesTrap{label, dispatcher_.fetchLabel(type->getBaseType())});
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

}  // namespace codeql
