#include "swift/extractor/translators/PatternTranslator.h"

namespace codeql {

codeql::NamedPattern PatternTranslator::translateNamedPattern(const swift::NamedPattern& pattern) {
  auto entry = dispatcher.createEntry(pattern);
  // TODO: in some (but not all) cases, this seems to introduce a duplicate entry
  // for example the vars listed in a case stmt have a different pointer than then ones in
  // patterns.
  //  assert(pattern.getDecl() && "expect NamedPattern to have Decl");
  //  dispatcher.emit(NamedPatternsTrap{label, pattern.getNameStr().str(),
  //                                       dispatcher.fetchLabel(pattern.getDecl())});
  entry.name = pattern.getNameStr().str();
  return entry;
}

codeql::TypedPattern PatternTranslator::translateTypedPattern(const swift::TypedPattern& pattern) {
  auto entry = dispatcher.createEntry(pattern);
  entry.sub_pattern = dispatcher.fetchLabel(pattern.getSubPattern());
  entry.type_repr = dispatcher.fetchOptionalLabel(pattern.getTypeRepr(), pattern.getType());
  return entry;
}

codeql::TuplePattern PatternTranslator::translateTuplePattern(const swift::TuplePattern& pattern) {
  auto entry = dispatcher.createEntry(pattern);
  for (const auto& p : pattern.getElements()) {
    entry.elements.push_back(dispatcher.fetchLabel(p.getPattern()));
  }
  return entry;
}
codeql::AnyPattern PatternTranslator::translateAnyPattern(const swift::AnyPattern& pattern) {
  auto entry = dispatcher.createEntry(pattern);
  return entry;
}

codeql::BindingPattern PatternTranslator::translateBindingPattern(
    const swift::BindingPattern& pattern) {
  auto entry = dispatcher.createEntry(pattern);
  entry.sub_pattern = dispatcher.fetchLabel(pattern.getSubPattern());
  return entry;
}

codeql::EnumElementPattern PatternTranslator::translateEnumElementPattern(
    const swift::EnumElementPattern& pattern) {
  auto entry = dispatcher.createEntry(pattern);
  entry.element = dispatcher.fetchLabel(pattern.getElementDecl());
  entry.sub_pattern = dispatcher.fetchOptionalLabel(pattern.getSubPattern());
  return entry;
}

codeql::OptionalSomePattern PatternTranslator::translateOptionalSomePattern(
    const swift::OptionalSomePattern& pattern) {
  auto entry = dispatcher.createEntry(pattern);
  entry.sub_pattern = dispatcher.fetchLabel(pattern.getSubPattern());
  return entry;
}

codeql::IsPattern PatternTranslator::translateIsPattern(const swift::IsPattern& pattern) {
  auto entry = dispatcher.createEntry(pattern);
  entry.cast_type_repr =
      dispatcher.fetchOptionalLabel(pattern.getCastTypeRepr(), pattern.getCastType());
  entry.sub_pattern = dispatcher.fetchOptionalLabel(pattern.getSubPattern());
  return entry;
}

codeql::ExprPattern PatternTranslator::translateExprPattern(const swift::ExprPattern& pattern) {
  auto entry = dispatcher.createEntry(pattern);
  entry.sub_expr = dispatcher.fetchLabel(pattern.getSubExpr());
  return entry;
}

codeql::ParenPattern PatternTranslator::translateParenPattern(const swift::ParenPattern& pattern) {
  auto entry = dispatcher.createEntry(pattern);
  entry.sub_pattern = dispatcher.fetchLabel(pattern.getSubPattern());
  return entry;
}

codeql::BoolPattern PatternTranslator::translateBoolPattern(const swift::BoolPattern& pattern) {
  auto entry = dispatcher.createEntry(pattern);
  entry.value = pattern.getValue();
  return entry;
}

}  // namespace codeql
