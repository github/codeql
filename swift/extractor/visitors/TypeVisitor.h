#pragma once

#include "swift/extractor/visitors/VisitorBase.h"
#include "swift/extractor/trap/generated/type/TrapClasses.h"

namespace codeql {
class TypeVisitor : public TypeVisitorBase<TypeVisitor> {
 public:
  using TypeVisitorBase<TypeVisitor>::TypeVisitorBase;

  void visit(swift::TypeBase* type);
  codeql::TypeRepr translateTypeRepr(const swift::TypeRepr& typeRepr, swift::Type type);

  void visitProtocolType(swift::ProtocolType* type);
  void visitEnumType(swift::EnumType* type);
  void visitStructType(swift::StructType* type);
  void visitClassType(swift::ClassType* type);
  void visitFunctionType(swift::FunctionType* type);
  void visitTupleType(swift::TupleType* type);
  void visitBoundGenericEnumType(swift::BoundGenericEnumType* type);
  void visitMetatypeType(swift::MetatypeType* type);
  void visitExistentialMetatypeType(swift::ExistentialMetatypeType* type);
  void visitBoundGenericStructType(swift::BoundGenericStructType* type);
  void visitTypeAliasType(swift::TypeAliasType* type);
  void visitBuiltinIntegerLiteralType(swift::BuiltinIntegerLiteralType* type);
  void visitBuiltinFloatType(swift::BuiltinFloatType* type);
  void visitBuiltinIntegerType(swift::BuiltinIntegerType* type);
  void visitBoundGenericClassType(swift::BoundGenericClassType* type);
  void visitDependentMemberType(swift::DependentMemberType* type);
  void visitParenType(swift::ParenType* type);
  void visitUnarySyntaxSugarType(swift::UnarySyntaxSugarType* type);
  codeql::OptionalType translateOptionalType(const swift::OptionalType& type);
  codeql::ArraySliceType translateArraySliceType(const swift::ArraySliceType& type);
  void visitDictionaryType(swift::DictionaryType* type);
  void visitGenericFunctionType(swift::GenericFunctionType* type);
  void visitGenericTypeParamType(swift::GenericTypeParamType* type);
  void visitLValueType(swift::LValueType* type);
  void visitUnboundGenericType(swift::UnboundGenericType* type);
  void visitBoundGenericType(swift::BoundGenericType* type);
  codeql::PrimaryArchetypeType translatePrimaryArchetypeType(
      const swift::PrimaryArchetypeType& type);
  codeql::NestedArchetypeType translateNestedArchetypeType(const swift::NestedArchetypeType& type);
  codeql::ExistentialType translateExistentialType(const swift::ExistentialType& type);
  codeql::DynamicSelfType translateDynamicSelfType(const swift::DynamicSelfType& type);
  codeql::VariadicSequenceType translateVariadicSequenceType(
      const swift::VariadicSequenceType& type);
  codeql::InOutType translateInOutType(const swift::InOutType& type);
  codeql::UnmanagedStorageType translateUnmanagedStorageType(
      const swift::UnmanagedStorageType& type);
  codeql::WeakStorageType translateWeakStorageType(const swift::WeakStorageType& type);
  codeql::UnownedStorageType translateUnownedStorageType(const swift::UnownedStorageType& type);
  codeql::ProtocolCompositionType translateProtocolCompositionType(
      const swift::ProtocolCompositionType& type);
  codeql::BuiltinIntegerLiteralType translateBuiltinIntegerLiteralType(
      const swift::BuiltinIntegerLiteralType& type);
  codeql::BuiltinIntegerType translateBuiltinIntegerType(const swift::BuiltinIntegerType& type);
  codeql::BuiltinBridgeObjectType translateBuiltinBridgeObjectType(
      const swift::BuiltinBridgeObjectType& type);
  codeql::BuiltinDefaultActorStorageType translateBuiltinDefaultActorStorageType(
      const swift::BuiltinDefaultActorStorageType& type);
  codeql::BuiltinExecutorType translateBuiltinExecutorType(const swift::BuiltinExecutorType& type);
  codeql::BuiltinFloatType translateBuiltinFloatType(const swift::BuiltinFloatType& type);
  codeql::BuiltinJobType translateBuiltinJobType(const swift::BuiltinJobType& type);
  codeql::BuiltinNativeObjectType translateBuiltinNativeObjectType(
      const swift::BuiltinNativeObjectType& type);
  codeql::BuiltinRawPointerType translateBuiltinRawPointerType(
      const swift::BuiltinRawPointerType& type);
  codeql::BuiltinRawUnsafeContinuationType translateBuiltinRawUnsafeContinuationType(
      const swift::BuiltinRawUnsafeContinuationType& type);
  codeql::BuiltinUnsafeValueBufferType translateBuiltinUnsafeValueBufferType(
      const swift::BuiltinUnsafeValueBufferType& type);
  codeql::BuiltinVectorType translateBuiltinVectorType(const swift::BuiltinVectorType& type);
  codeql::OpenedArchetypeType translateOpenedArchetypeType(const swift::OpenedArchetypeType& type);
  codeql::ModuleType translateModuleType(const swift::ModuleType& type);

 private:
  void fillType(const swift::TypeBase& type, codeql::Type& entry);
  void fillArchetypeType(const swift::ArchetypeType& type, codeql::ArchetypeType& entry);
  void fillUnarySyntaxSugarType(const swift::UnarySyntaxSugarType& type,
                                codeql::UnarySyntaxSugarType& entry);
  void fillReferenceStorageType(const swift::ReferenceStorageType& type,
                                codeql::ReferenceStorageType& entry);
  void emitAnyFunctionType(const swift::AnyFunctionType* type, TrapLabel<AnyFunctionTypeTag> label);
  void emitBoundGenericType(swift::BoundGenericType* type, TrapLabel<BoundGenericTypeTag> label);
  void emitAnyGenericType(swift::AnyGenericType* type, TrapLabel<AnyGenericTypeTag> label);

  template <typename T, typename... Args>
  auto createTypeEntry(const T& type, const Args&... args) {
    auto entry = dispatcher_.createEntry(type, args...);
    fillType(type, entry);
    return entry;
  }
};

}  // namespace codeql
