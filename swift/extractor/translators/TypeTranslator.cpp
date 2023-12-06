#include "swift/extractor/translators/TypeTranslator.h"

namespace codeql {

void TypeTranslator::translateAndEmit(const swift::TypeRepr& typeRepr, swift::Type type) {
  auto entry = dispatcher.createEntry(typeRepr);
  entry.type = dispatcher.fetchLabel(type);
  dispatcher.emit(entry);
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
    entry.types.push_back(dispatcher.fetchLabel(e.getType()));
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
  entry.decl = dispatcher.fetchLabel(type.getDecl());
  return entry;
}

codeql::DependentMemberType TypeTranslator::translateDependentMemberType(
    const swift::DependentMemberType& type) {
  auto entry = createTypeEntry(type);
  entry.base_type = dispatcher.fetchLabel(type.getBase());
  entry.associated_type_decl = dispatcher.fetchLabel(type.getAssocType());
  return entry;
}

codeql::ParenType TypeTranslator::translateParenType(const swift::ParenType& type) {
  auto entry = createTypeEntry(type);
  entry.type = dispatcher.fetchLabel(type.getUnderlyingType());
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
  entry.key_type = dispatcher.fetchLabel(type.getKeyType());
  entry.value_type = dispatcher.fetchLabel(type.getValueType());
  return entry;
}

codeql::GenericFunctionType TypeTranslator::translateGenericFunctionType(
    const swift::GenericFunctionType& type) {
  auto entry = createTypeEntry(type);
  fillAnyFunctionType(type, entry);
  entry.generic_params = dispatcher.fetchRepeatedLabels(type.getGenericParams());
  return entry;
}

codeql::GenericTypeParamType TypeTranslator::translateGenericTypeParamType(
    const swift::GenericTypeParamType& type) {
  auto entry = createTypeEntry(type);
  return entry;
}

codeql::LValueType TypeTranslator::translateLValueType(const swift::LValueType& type) {
  auto entry = createTypeEntry(type);
  entry.object_type = dispatcher.fetchLabel(type.getObjectType());
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
  entry.base_type = dispatcher.fetchLabel(type.getBaseType());
}

void TypeTranslator::fillAnyFunctionType(const swift::AnyFunctionType& type,
                                         codeql::AnyFunctionType& entry) {
  entry.result = dispatcher.fetchLabel(type.getResult());
  for (const auto& p : type.getParams()) {
    entry.param_types.push_back(dispatcher.fetchLabel(p.getPlainType()));
  }
  entry.is_throwing = type.isThrowing();
  entry.is_async = type.isAsync();
}

void TypeTranslator::fillBoundGenericType(const swift::BoundGenericType& type,
                                          codeql::BoundGenericType& entry) {
  entry.arg_types = dispatcher.fetchRepeatedLabels(type.getGenericArgs());
  fillAnyGenericType(type, entry);
}

void TypeTranslator::fillAnyGenericType(const swift::AnyGenericType& type,
                                        codeql::AnyGenericType& entry) {
  entry.declaration = dispatcher.fetchLabel(type.getDecl());
  entry.parent = dispatcher.fetchOptionalLabel(type.getParent());
}

void TypeTranslator::fillType(const swift::TypeBase& type, codeql::Type& entry) {
  // Preserve the order as getCanonicalType() forces computation of the canonical type
  // without which getString may crash sometimes
  entry.canonical_type = dispatcher.fetchLabel(type.getCanonicalType());
  entry.name = type.getString();
}

void TypeTranslator::fillArchetypeType(const swift::ArchetypeType& type, ArchetypeType& entry) {
  entry.interface_type = dispatcher.fetchLabel(type.getInterfaceType());
  entry.protocols = dispatcher.fetchRepeatedLabels(type.getConformsTo());
  entry.superclass = dispatcher.fetchOptionalLabel(type.getSuperclass());
}

codeql::ExistentialType TypeTranslator::translateExistentialType(
    const swift::ExistentialType& type) {
  auto entry = createTypeEntry(type);
  entry.constraint = dispatcher.fetchLabel(type.getConstraintType());
  return entry;
}

codeql::DynamicSelfType TypeTranslator::translateDynamicSelfType(
    const swift::DynamicSelfType& type) {
  auto entry = createTypeEntry(type);
  entry.static_self_type = dispatcher.fetchLabel(type.getSelfType());
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
  entry.object_type = dispatcher.fetchLabel(type.getObjectType());
  return entry;
}

void TypeTranslator::fillReferenceStorageType(const swift::ReferenceStorageType& type,
                                              codeql::ReferenceStorageType& entry) {
  entry.referent_type = dispatcher.fetchLabel(type.getReferentType());
}

codeql::ProtocolCompositionType TypeTranslator::translateProtocolCompositionType(
    const swift::ProtocolCompositionType& type) {
  auto entry = createTypeEntry(type);
  entry.members = dispatcher.fetchRepeatedLabels(type.getMembers());
  return entry;
}

codeql::BuiltinIntegerLiteralType TypeTranslator::translateBuiltinIntegerLiteralType(
    const swift::BuiltinIntegerLiteralType& type) {
  // currently the translate dispatching mechanism does not go up more than one step in the
  // hierarchy so we need to put this explicitly here, as BuiltinIntegerLiteralType derives from
  // AnyBuiltinIntegerType which then derives from BuiltinType
  return translateBuiltinType(type);
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
  auto entry = createTypeEntry(type);
  entry.module = dispatcher.fetchLabel(type.getModule());
  return entry;
}

codeql::OpaqueTypeArchetypeType TypeTranslator::translateOpaqueTypeArchetypeType(
    const swift::OpaqueTypeArchetypeType& type) {
  auto entry = createTypeEntry(type);
  fillArchetypeType(type, entry);
  entry.declaration = dispatcher.fetchLabel(type.getDecl());
  return entry;
}

codeql::ErrorType TypeTranslator::translateErrorType(const swift::ErrorType& type) {
  return createTypeEntry(type);
}

codeql::UnresolvedType TypeTranslator::translateUnresolvedType(const swift::UnresolvedType& type) {
  return createTypeEntry(type);
}

codeql::ParameterizedProtocolType TypeTranslator::translateParameterizedProtocolType(
    const swift::ParameterizedProtocolType& type) {
  auto entry = createTypeEntry(type);
  entry.base = dispatcher.fetchLabel(type.getBaseType());
  entry.args = dispatcher.fetchRepeatedLabels(type.getArgs());
  return entry;
}

codeql::PackArchetypeType TypeTranslator::translatePackArchetypeType(
    const swift::PackArchetypeType& type) {
  auto entry = createTypeEntry(type);
  fillArchetypeType(type, entry);
  return entry;
}

codeql::ElementArchetypeType TypeTranslator::translateElementArchetypeType(
    const swift::ElementArchetypeType& type) {
  auto entry = createTypeEntry(type);
  fillArchetypeType(type, entry);
  return entry;
}

codeql::PackType TypeTranslator::translatePackType(const swift::PackType& type) {
  auto entry = createTypeEntry(type);
  entry.elements = dispatcher.fetchRepeatedLabels(type.getElementTypes());
  return entry;
}

codeql::PackElementType TypeTranslator::translatePackElementType(
    const swift::PackElementType& type) {
  auto entry = createTypeEntry(type);
  entry.pack_type = dispatcher.fetchLabel(type.getPackType());
  return entry;
}

codeql::PackExpansionType TypeTranslator::translatePackExpansionType(
    const swift::PackExpansionType& type) {
  auto entry = createTypeEntry(type);
  entry.pattern_type = dispatcher.fetchLabel(type.getPatternType());
  entry.count_type = dispatcher.fetchLabel(type.getCountType());
  return entry;
}

}  // namespace codeql
