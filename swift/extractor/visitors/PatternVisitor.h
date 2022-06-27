#pragma once

#include "swift/extractor/visitors/VisitorBase.h"
#include "swift/extractor/trap/generated/pattern/TrapClasses.h"

namespace codeql {

class PatternVisitor : public AstVisitorBase<PatternVisitor> {
 public:
  using AstVisitorBase<PatternVisitor>::AstVisitorBase;

  void visitNamedPattern(swift::NamedPattern* pattern);
  void visitTypedPattern(swift::TypedPattern* pattern);
  void visitTuplePattern(swift::TuplePattern* pattern);
  void visitAnyPattern(swift::AnyPattern* pattern);
  void visitBindingPattern(swift::BindingPattern* pattern);
  void visitEnumElementPattern(swift::EnumElementPattern* pattern);
  void visitOptionalSomePattern(swift::OptionalSomePattern* pattern);
  void visitIsPattern(swift::IsPattern* pattern);
  void visitExprPattern(swift::ExprPattern* pattern);
  void visitParenPattern(swift::ParenPattern* pattern);
  void visitBoolPattern(swift::BoolPattern* pattern);
};
}  // namespace codeql
