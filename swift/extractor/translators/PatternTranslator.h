#pragma once

#include "swift/extractor/translators/TranslatorBase.h"
#include "swift/extractor/trap/generated/pattern/TrapClasses.h"

namespace codeql {

class PatternTranslator : public AstTranslatorBase<PatternTranslator> {
 public:
  using AstTranslatorBase<PatternTranslator>::AstTranslatorBase;

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
