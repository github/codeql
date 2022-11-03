#pragma once

#include "swift/extractor/visitors/VisitorBase.h"
#include "swift/extractor/trap/generated/pattern/TrapClasses.h"

namespace codeql {

class PatternVisitor : public AstVisitorBase<PatternVisitor> {
 public:
  using AstVisitorBase<PatternVisitor>::AstVisitorBase;
  using AstVisitorBase<PatternVisitor>::visit;

  // TODO
  // swift does not provide const visitors, for the moment we const_cast and promise not to
  // change the entities. When all visitors have been turned to translators, we can ditch
  // swift::ASTVisitor and roll out our own const-correct TranslatorBase class
  void visit(const swift::Pattern* pattern) { visit(const_cast<swift::Pattern*>(pattern)); }

  codeql::NamedPattern translateNamedPattern(const swift::NamedPattern& pattern);
  codeql::TypedPattern translateTypedPattern(const swift::TypedPattern& pattern);
  codeql::TuplePattern translateTuplePattern(const swift::TuplePattern& pattern);
  codeql::AnyPattern translateAnyPattern(const swift::AnyPattern& pattern);
  codeql::BindingPattern translateBindingPattern(const swift::BindingPattern& pattern);
  codeql::EnumElementPattern translateEnumElementPattern(const swift::EnumElementPattern& pattern);
  codeql::OptionalSomePattern translateOptionalSomePattern(
      const swift::OptionalSomePattern& pattern);
  codeql::IsPattern translateIsPattern(const swift::IsPattern& pattern);
  codeql::ExprPattern translateExprPattern(const swift::ExprPattern& pattern);
  codeql::ParenPattern translateParenPattern(const swift::ParenPattern& pattern);
  codeql::BoolPattern translateBoolPattern(const swift::BoolPattern& pattern);
};
}  // namespace codeql
