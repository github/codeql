#include "swift/extractor/translators/TypeTranslator.h"

namespace codeql {

codeql::TypeRepr TypeTranslator::translateTypeRepr(const swift::TypeRepr& typeRepr,
                                                   swift::Type type) {
  auto entry = dispatcher_.createEntry(typeRepr);
  entry.type = dispatcher_.fetchLabel(type);
  return entry;
}

codeql::ProtocolType TypeTranslator::translateProtocolType(const swift::ProtocolType& type) {
  auto entry = createTypeEntry(type);
  fillAnyGenericType(type, entry);
  return entry;
}

codeql::EnumType TypeTranslator::translateEnumType(const swift::EnumType& type) {
  auto entry = createTypeEntry(type);
  fillAnyGenericType(type, entry);
  return entry;
}

codeql::StructType TypeTranslator::translateStructType(const swift::StructType& type) {
  auto entry = createTypeEntry(type);
  fillAnyGenericType(type, entry);
  return entry;
}

codeql::ClassType TypeTranslator::translateClassType(const swift::ClassType& type) {
  auto entry = createTypeEntry(type);
  fillAnyGenericType(type, entry);
  return entry;
}

codeql::FunctionType TypeTranslator::translateFunctionType(const swift::FunctionType& type) {
  auto entry = createTypeEntry(type);
  fillAnyFunctionType(type, entry);
  return entry;
}

codeql::TupleType TypeTranslator::translateTupleType(const swift::TupleType& type) {
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

codeql::MetatypeType TypeTranslator::translateMetatypeType(const swift::MetatypeType& type) {
  auto entry = createTypeEntry(type);
  return entry;
}

codeql::ExistentialMetatypeType TypeTranslator::translateExistentialMetatypeType(
    const swift::ExistentialMetatypeType& type) {
  auto entry = createTypeEntry(type);
  return entry;
}

codeql::TypeAliasType TypeTranslator::translateTypeAliasType(const swift::TypeAliasType& type) {
  auto entry = createTypeEntry(type);
  entry.decl = dispatcher_.fetchLabel(type.getDecl());
  return entry;
}

codeql::DependentMemberType TypeTranslator::translateDependentMemberType(
    const swift::DependentMemberType& type) {
  auto entry = createTypeEntry(type);
  entry.base_type = dispatcher_.fetchLabel(type.getBase());
  entry.associated_type_decl = dispatcher_.fetchLabel(type.getAssocType());
  return entry;
}

codeql::ParenType TypeTranslator::translateParenType(const swift::ParenType& type) {
  auto entry = createTypeEntry(type);
  entry.type = dispatcher_.fetchLabel(type.getUnderlyingType());
  return entry;
}

codeql::OptionalType TypeTranslator::translateOptionalType(const swift::OptionalType& type) {
  auto entry = createTypeEntry(type);
  fillUnarySyntaxSugarType(type, entry);
  return entry;
}

codeql::ArraySliceType TypeTranslator::translateArraySliceType(const swift::ArraySliceType& type) {
  auto entry = createTypeEntry(type);
  fillUnarySyntaxSugarType(type, entry);
  return entry;
}

codeql::DictionaryType TypeTranslator::translateDictionaryType(const swift::DictionaryType& type) {
  auto entry = createTypeEntry(type);
  entry.key_type = dispatcher_.fetchLabel(type.getKeyType());
  entry.value_type = dispatcher_.fetchLabel(type.getValueType());
  return entry;
}

codeql::GenericFunctionType TypeTranslator::translateGenericFunctionType(
    const swift::GenericFunctionType& type) {
  auto entry = createTypeEntry(type);
  fillAnyFunctionType(type, entry);
  entry.generic_params = dispatcher_.fetchRepeatedLabels(type.getGenericParams());
  return entry;
}

codeql::GenericTypeParamType TypeTranslator::translateGenericTypeParamType(
    const swift::GenericTypeParamType& type) {
  auto entry = createTypeEntry(type);
  return entry;
}

codeql::LValueType TypeTranslator::translateLValueType(const swift::LValueType& type) {
  auto entry = createTypeEntry(type);
  entry.object_type = dispatcher_.fetchLabel(type.getObjectType());
  return entry;
}

codeql::PrimaryArchetypeType TypeTranslator::translatePrimaryArchetypeType(
    const swift::PrimaryArchetypeType& type) {
  auto entry = createTypeEntry(type);
  fillArchetypeType(type, entry);
  return entry;
}

codeql::UnboundGenericType TypeTranslator::translateUnboundGenericType(
    const swift::UnboundGenericType& type) {
  auto entry = createTypeEntry(type);
  fillAnyGenericType(type, entry);
  return entry;
}

void TypeTranslator::fillUnarySyntaxSugarType(const swift::UnarySyntaxSugarType& type,
                                              codeql::UnarySyntaxSugarType& entry) {
  entry.base_type = dispatcher_.fetchLabel(type.getBaseType());
}

void TypeTranslator::fillAnyFunctionType(const swift::AnyFunctionType& type,
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

void TypeTranslator::fillBoundGenericType(const swift::BoundGenericType& type,
                                          codeql::BoundGenericType& entry) {
  entry.arg_types = dispatcher_.fetchRepeatedLabels(type.getGenericArgs());
  fillAnyGenericType(type, entry);
}

void TypeTranslator::fillAnyGenericType(const swift::AnyGenericType& type,
                                        codeql::AnyGenericType& entry) {
  entry.declaration = dispatcher_.fetchLabel(type.getDecl());
  entry.parent = dispatcher_.fetchOptionalLabel(type.getParent());
}

void TypeTranslator::fillType(const swift::TypeBase& type, codeql::Type& entry) {
  entry.name = type.getString();
  entry.canonical_type = dispatcher_.fetchLabel(type.getCanonicalType());
}

void TypeTranslator::fillArchetypeType(const swift::ArchetypeType& type, ArchetypeType& entry) {
  entry.interface_type = dispatcher_.fetchLabel(type.getInterfaceType());
  entry.protocols = dispatcher_.fetchRepeatedLabels(type.getConformsTo());
  entry.superclass = dispatcher_.fetchOptionalLabel(type.getSuperclass());
}

codeql::ExistentialType TypeTranslator::translateExistentialType(
    const swift::ExistentialType& type) {
  auto entry = createTypeEntry(type);
  entry.constraint = dispatcher_.fetchLabel(type.getConstraintType());
  return entry;
}

codeql::DynamicSelfType TypeTranslator::translateDynamicSelfType(
    const swift::DynamicSelfType& type) {
  auto entry = createTypeEntry(type);
  entry.static_self_type = dispatcher_.fetchLabel(type.getSelfType());
  return entry;
}

codeql::VariadicSequenceType TypeTranslator::translateVariadicSequenceType(
    const swift::VariadicSequenceType& type) {
  auto entry = createTypeEntry(type);
  fillUnarySyntaxSugarType(type, entry);
  return entry;
}

codeql::InOutType TypeTranslator::translateInOutType(const swift::InOutType& type) {
  auto entry = createTypeEntry(type);
  entry.object_type = dispatcher_.fetchLabel(type.getObjectType());
  return entry;
}

void TypeTranslator::fillReferenceStorageType(const swift::ReferenceStorageType& type,
                                              codeql::ReferenceStorageType& entry) {
  entry.referent_type = dispatcher_.fetchLabel(type.getReferentType());
}

codeql::ProtocolCompositionType TypeTranslator::translateProtocolCompositionType(
    const swift::ProtocolCompositionType& type) {
  auto entry = createTypeEntry(type);
  entry.members = dispatcher_.fetchRepeatedLabels(type.getMembers());
  return entry;
}

codeql::BuiltinIntegerType TypeTranslator::translateBuiltinIntegerType(
    const swift::BuiltinIntegerType& type) {
  auto entry = createTypeEntry(type);
  if (type.isFixedWidth()) {
    entry.width = type.getFixedWidth();
  }
  return entry;
}

codeql::OpenedArchetypeType TypeTranslator::translateOpenedArchetypeType(
    const swift::OpenedArchetypeType& type) {
  auto entry = createTypeEntry(type);
  fillArchetypeType(type, entry);
  return entry;
}

codeql::ModuleType TypeTranslator::translateModuleType(const swift::ModuleType& type) {
  auto key = type.getModule()->getRealName().str().str();
  if (type.getModule()->isNonSwiftModule()) {
    key += "|clang";
  }
  auto entry = createTypeEntry(type, key);
  entry.module = dispatcher_.fetchLabel(type.getModule());
  return entry;
}
}  // namespace codeql
