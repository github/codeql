#pragma once

#include "swift/extractor/translators/TranslatorBase.h"
#include "swift/extractor/trap/generated/type/TrapClasses.h"

namespace codeql {
class TypeTranslator : public TypeTranslatorBase<TypeTranslator> {
 public:
  static constexpr std::string_view name = "type";

  using TypeTranslatorBase<TypeTranslator>::TypeTranslatorBase;
  using TypeTranslatorBase<TypeTranslator>::translateAndEmit;

  void translateAndEmit(const swift::TypeRepr& typeRepr, swift::Type type);

  codeql::ProtocolType translateProtocolType(const swift::ProtocolType& type);
  codeql::EnumType translateEnumType(const swift::EnumType& type);
  codeql::StructType translateStructType(const swift::StructType& type);
  codeql::ClassType translateClassType(const swift::ClassType& type);
  codeql::FunctionType translateFunctionType(const swift::FunctionType& type);
  codeql::TupleType translateTupleType(const swift::TupleType& type);
  codeql::MetatypeType translateMetatypeType(const swift::MetatypeType& type);
  codeql::ExistentialMetatypeType translateExistentialMetatypeType(
      const swift::ExistentialMetatypeType& type);
  codeql::TypeAliasType translateTypeAliasType(const swift::TypeAliasType& type);
  codeql::DependentMemberType translateDependentMemberType(const swift::DependentMemberType& type);
  codeql::ParenType translateParenType(const swift::ParenType& type);
  codeql::UnarySyntaxSugarType translateUnarySyntaxSugarType(
      const swift::UnarySyntaxSugarType& type);
  codeql::OptionalType translateOptionalType(const swift::OptionalType& type);
  codeql::ArraySliceType translateArraySliceType(const swift::ArraySliceType& type);
  codeql::DictionaryType translateDictionaryType(const swift::DictionaryType& type);
  codeql::GenericFunctionType translateGenericFunctionType(const swift::GenericFunctionType& type);
  codeql::GenericTypeParamType translateGenericTypeParamType(
      const swift::GenericTypeParamType& type);
  codeql::LValueType translateLValueType(const swift::LValueType& type);
  codeql::UnboundGenericType translateUnboundGenericType(const swift::UnboundGenericType& type);

  template <typename Type>
  codeql::TrapClassOf<Type> translateBoundGenericType(const Type& type) {
    auto entry = createTypeEntry(type);
    fillBoundGenericType(type, entry);
    return entry;
  }

  codeql::PrimaryArchetypeType translatePrimaryArchetypeType(
      const swift::PrimaryArchetypeType& type);
  codeql::ExistentialType translateExistentialType(const swift::ExistentialType& type);
  codeql::DynamicSelfType translateDynamicSelfType(const swift::DynamicSelfType& type);
  codeql::VariadicSequenceType translateVariadicSequenceType(
      const swift::VariadicSequenceType& type);
  codeql::InOutType translateInOutType(const swift::InOutType& type);

  template <typename Type>
  codeql::TrapClassOf<Type> translateReferenceStorageType(const Type& type) {
    auto entry = createTypeEntry(type);
    fillReferenceStorageType(type, entry);
    return entry;
  }

  codeql::ProtocolCompositionType translateProtocolCompositionType(
      const swift::ProtocolCompositionType& type);

  template <typename Type>
  codeql::TrapClassOf<Type> translateBuiltinType(const Type& type) {
    return createTypeEntry(type);
  }

  codeql::BuiltinIntegerLiteralType translateBuiltinIntegerLiteralType(
      const swift::BuiltinIntegerLiteralType& type);
  codeql::BuiltinIntegerType translateBuiltinIntegerType(const swift::BuiltinIntegerType& type);
  codeql::OpenedArchetypeType translateOpenedArchetypeType(const swift::OpenedArchetypeType& type);
  codeql::ModuleType translateModuleType(const swift::ModuleType& type);
  codeql::OpaqueTypeArchetypeType translateOpaqueTypeArchetypeType(
      const swift::OpaqueTypeArchetypeType& type);
  codeql::ErrorType translateErrorType(const swift::ErrorType& type);
  codeql::UnresolvedType translateUnresolvedType(const swift::UnresolvedType& type);
  codeql::ParameterizedProtocolType translateParameterizedProtocolType(
      const swift::ParameterizedProtocolType& type);
  codeql::PackArchetypeType translatePackArchetypeType(const swift::PackArchetypeType& type);
  codeql::ElementArchetypeType translateElementArchetypeType(
      const swift::ElementArchetypeType& type);
  codeql::PackType translatePackType(const swift::PackType& type);
  codeql::PackElementType translatePackElementType(const swift::PackElementType& type);
  codeql::PackExpansionType translatePackExpansionType(const swift::PackExpansionType& type);

 private:
  void fillType(const swift::TypeBase& type, codeql::Type& entry);
  void fillArchetypeType(const swift::ArchetypeType& type, codeql::ArchetypeType& entry);
  void fillUnarySyntaxSugarType(const swift::UnarySyntaxSugarType& type,
                                codeql::UnarySyntaxSugarType& entry);
  void fillReferenceStorageType(const swift::ReferenceStorageType& type,
                                codeql::ReferenceStorageType& entry);
  void fillAnyFunctionType(const swift::AnyFunctionType& type, codeql::AnyFunctionType& entry);
  void fillBoundGenericType(const swift::BoundGenericType& type, codeql::BoundGenericType& entry);
  void fillAnyGenericType(const swift::AnyGenericType& type, codeql::AnyGenericType& entry);

  template <typename T>
  auto createTypeEntry(const T& type) {
    auto entry = dispatcher.createEntry(type);
    fillType(type, entry);
    return entry;
  }
};

}  // namespace codeql
