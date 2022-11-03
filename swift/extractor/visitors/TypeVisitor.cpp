#include "swift/extractor/visitors/TypeVisitor.h"

namespace codeql {

codeql::TypeRepr TypeVisitor::translateTypeRepr(const swift::TypeRepr& typeRepr, swift::Type type) {
  auto entry = dispatcher_.createEntry(typeRepr);
  entry.type = dispatcher_.fetchLabel(type);
  return entry;
}

codeql::ProtocolType TypeVisitor::translateProtocolType(const swift::ProtocolType& type) {
  auto entry = createTypeEntry(type);
  fillAnyGenericType(type, entry);
  return entry;
}

codeql::EnumType TypeVisitor::translateEnumType(const swift::EnumType& type) {
  auto entry = createTypeEntry(type);
  fillAnyGenericType(type, entry);
  return entry;
}

codeql::StructType TypeVisitor::translateStructType(const swift::StructType& type) {
  auto entry = createTypeEntry(type);
  fillAnyGenericType(type, entry);
  return entry;
}

codeql::ClassType TypeVisitor::translateClassType(const swift::ClassType& type) {
  auto entry = createTypeEntry(type);
  fillAnyGenericType(type, entry);
  return entry;
}

codeql::FunctionType TypeVisitor::translateFunctionType(const swift::FunctionType& type) {
  auto entry = createTypeEntry(type);
  fillAnyFunctionType(type, entry);
  return entry;
}

codeql::TupleType TypeVisitor::translateTupleType(const swift::TupleType& type) {
  auto entry = createTypeEntry(type);
  for (const auto& e : type.getElements()) {
    entry.types.push_back(dispatcher_.fetchLabel(e.getType()));
    if (e.hasName()) {
      entry.names.emplace_back(e.getName().str().str());
    } else {
      entry.names.emplace_back();
    }
  }
  return entry;
}

codeql::MetatypeType TypeVisitor::translateMetatypeType(const swift::MetatypeType& type) {
  auto entry = createTypeEntry(type);
  return entry;
}

codeql::ExistentialMetatypeType TypeVisitor::translateExistentialMetatypeType(
    const swift::ExistentialMetatypeType& type) {
  auto entry = createTypeEntry(type);
  return entry;
}

codeql::TypeAliasType TypeVisitor::translateTypeAliasType(const swift::TypeAliasType& type) {
  auto entry = createTypeEntry(type);
  entry.decl = dispatcher_.fetchLabel(type.getDecl());
  return entry;
}

codeql::DependentMemberType TypeVisitor::translateDependentMemberType(
    const swift::DependentMemberType& type) {
  auto entry = createTypeEntry(type);
  entry.base_type = dispatcher_.fetchLabel(type.getBase());
  entry.associated_type_decl = dispatcher_.fetchLabel(type.getAssocType());
  return entry;
}

codeql::ParenType TypeVisitor::translateParenType(const swift::ParenType& type) {
  auto entry = createTypeEntry(type);
  entry.type = dispatcher_.fetchLabel(type.getUnderlyingType());
  return entry;
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

codeql::DictionaryType TypeVisitor::translateDictionaryType(const swift::DictionaryType& type) {
  auto entry = createTypeEntry(type);
  entry.key_type = dispatcher_.fetchLabel(type.getKeyType());
  entry.value_type = dispatcher_.fetchLabel(type.getValueType());
  return entry;
}

codeql::GenericFunctionType TypeVisitor::translateGenericFunctionType(
    const swift::GenericFunctionType& type) {
  auto entry = createTypeEntry(type);
  fillAnyFunctionType(type, entry);
  entry.generic_params = dispatcher_.fetchRepeatedLabels(type.getGenericParams());
  return entry;
}

codeql::GenericTypeParamType TypeVisitor::translateGenericTypeParamType(
    const swift::GenericTypeParamType& type) {
  auto entry = createTypeEntry(type);
  return entry;
}

codeql::LValueType TypeVisitor::translateLValueType(const swift::LValueType& type) {
  auto entry = createTypeEntry(type);
  entry.object_type = dispatcher_.fetchLabel(type.getObjectType());
  return entry;
}

codeql::PrimaryArchetypeType TypeVisitor::translatePrimaryArchetypeType(
    const swift::PrimaryArchetypeType& type) {
  auto entry = createTypeEntry(type);
  fillArchetypeType(type, entry);
  return entry;
}

codeql::UnboundGenericType TypeVisitor::translateUnboundGenericType(
    const swift::UnboundGenericType& type) {
  auto entry = createTypeEntry(type);
  fillAnyGenericType(type, entry);
  return entry;
}

void TypeVisitor::fillUnarySyntaxSugarType(const swift::UnarySyntaxSugarType& type,
                                           codeql::UnarySyntaxSugarType& entry) {
  entry.base_type = dispatcher_.fetchLabel(type.getBaseType());
}

void TypeVisitor::fillAnyFunctionType(const swift::AnyFunctionType& type,
                                      codeql::AnyFunctionType& entry) {
  entry.result = dispatcher_.fetchLabel(type.getResult());
  for (const auto& p : type.getParams()) {
    entry.param_types.push_back(dispatcher_.fetchLabel(p.getPlainType()));
    if (p.hasLabel()) {
      entry.param_labels.emplace_back(p.getLabel().str().str());
    } else {
      entry.param_labels.emplace_back();
    }
  }
  entry.is_throwing = type.isThrowing();
  entry.is_async = type.isAsync();
}

void TypeVisitor::fillBoundGenericType(const swift::BoundGenericType& type,
                                       codeql::BoundGenericType& entry) {
  entry.arg_types = dispatcher_.fetchRepeatedLabels(type.getGenericArgs());
  fillAnyGenericType(type, entry);
}

void TypeVisitor::fillAnyGenericType(const swift::AnyGenericType& type,
                                     codeql::AnyGenericType& entry) {
  entry.declaration = dispatcher_.fetchLabel(type.getDecl());
  entry.parent = dispatcher_.fetchOptionalLabel(type.getParent());
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

void TypeVisitor::fillReferenceStorageType(const swift::ReferenceStorageType& type,
                                           codeql::ReferenceStorageType& entry) {
  entry.referent_type = dispatcher_.fetchLabel(type.getReferentType());
}

codeql::ProtocolCompositionType TypeVisitor::translateProtocolCompositionType(
    const swift::ProtocolCompositionType& type) {
  auto entry = createTypeEntry(type);
  entry.members = dispatcher_.fetchRepeatedLabels(type.getMembers());
  return entry;
}

codeql::BuiltinIntegerType TypeVisitor::translateBuiltinIntegerType(
    const swift::BuiltinIntegerType& type) {
  auto entry = createTypeEntry(type);
  if (type.isFixedWidth()) {
    entry.width = type.getFixedWidth();
  }
  return entry;
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
