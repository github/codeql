#pragma once

#include "swift/extractor/visitors/VisitorBase.h"
#include "swift/extractor/trap/generated/type/TrapClasses.h"

namespace codeql {
class TypeVisitor : public TypeVisitorBase<TypeVisitor> {
 public:
  using TypeVisitorBase<TypeVisitor>::TypeVisitorBase;

  void visit(swift::TypeBase* type);
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
  void visitOptionalType(swift::OptionalType* type);
  void visitArraySliceType(swift::ArraySliceType* type);
  void visitDictionaryType(swift::DictionaryType* type);
  void visitGenericFunctionType(swift::GenericFunctionType* type);
  void visitGenericTypeParamType(swift::GenericTypeParamType* type);
  void visitLValueType(swift::LValueType* type);
  void visitPrimaryArchetypeType(swift::PrimaryArchetypeType* type);
  void visitUnboundGenericType(swift::UnboundGenericType* type);
  void visitBoundGenericType(swift::BoundGenericType* type);

 private:
  void emitUnarySyntaxSugarType(const swift::UnarySyntaxSugarType* type,
                                TrapLabel<UnarySyntaxSugarTypeTag> label);
  void emitAnyFunctionType(const swift::AnyFunctionType* type, TrapLabel<AnyFunctionTypeTag> label);
  void emitBoundGenericType(swift::BoundGenericType* type, TrapLabel<BoundGenericTypeTag> label);
  void emitAnyGenericType(swift::AnyGenericType* type, TrapLabel<AnyGenericTypeTag> label);
};

}  // namespace codeql
