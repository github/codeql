#include "swift/extractor/visitors/PatternVisitor.h"

namespace codeql {

void PatternVisitor::visitNamedPattern(swift::NamedPattern* pattern) {
  auto label = dispatcher_.assignNewLabel(pattern);
  // TODO: in some (but not all) cases, this seems to introduce a duplicate entry
  // for example the vars listed in a case stmt have a different pointer than then ones in
  // patterns.
  //  assert(pattern->getDecl() && "expect NamedPattern to have Decl");
  //  dispatcher_.emit(NamedPatternsTrap{label, pattern->getNameStr().str(),
  //                                       dispatcher_.fetchLabel(pattern->getDecl())});
  dispatcher_.emit(NamedPatternsTrap{label, pattern->getNameStr().str()});
}

void PatternVisitor::visitTypedPattern(swift::TypedPattern* pattern) {
  auto label = dispatcher_.assignNewLabel(pattern);
  assert(pattern->getSubPattern() && "expect TypedPattern to have a SubPattern");
  dispatcher_.emit(TypedPatternsTrap{label, dispatcher_.fetchLabel(pattern->getSubPattern())});
  if (auto typeRepr = pattern->getTypeRepr()) {
    dispatcher_.emit(TypedPatternTypeReprsTrap{
        label, dispatcher_.fetchLabel(pattern->getTypeRepr(), pattern->getType())});
  }
}

void PatternVisitor::visitTuplePattern(swift::TuplePattern* pattern) {
  auto label = dispatcher_.assignNewLabel(pattern);
  dispatcher_.emit(TuplePatternsTrap{label});
  auto i = 0u;
  for (auto p : pattern->getElements()) {
    dispatcher_.emit(TuplePatternElementsTrap{label, i++, dispatcher_.fetchLabel(p.getPattern())});
  }
}
void PatternVisitor::visitAnyPattern(swift::AnyPattern* pattern) {
  dispatcher_.emit(AnyPatternsTrap{dispatcher_.assignNewLabel(pattern)});
}

void PatternVisitor::visitBindingPattern(swift::BindingPattern* pattern) {
  auto label = dispatcher_.assignNewLabel(pattern);
  assert(pattern->getSubPattern() && "expect BindingPattern to have a SubPattern");
  dispatcher_.emit(BindingPatternsTrap{label, dispatcher_.fetchLabel(pattern->getSubPattern())});
}

void PatternVisitor::visitEnumElementPattern(swift::EnumElementPattern* pattern) {
  auto label = dispatcher_.assignNewLabel(pattern);
  dispatcher_.emit(
      EnumElementPatternsTrap{label, dispatcher_.fetchLabel(pattern->getElementDecl())});
  if (auto subPattern = pattern->getSubPattern()) {
    dispatcher_.emit(
        EnumElementPatternSubPatternsTrap{label, dispatcher_.fetchLabel(pattern->getSubPattern())});
  }
}

void PatternVisitor::visitOptionalSomePattern(swift::OptionalSomePattern* pattern) {
  auto label = dispatcher_.assignNewLabel(pattern);
  assert(pattern->getSubPattern() && "expect BindingPattern to have a SubPattern");
  dispatcher_.emit(
      OptionalSomePatternsTrap{label, dispatcher_.fetchLabel(pattern->getSubPattern())});
}

void PatternVisitor::visitIsPattern(swift::IsPattern* pattern) {
  auto label = dispatcher_.assignNewLabel(pattern);
  dispatcher_.emit(IsPatternsTrap{label});

  if (auto typeRepr = pattern->getCastTypeRepr()) {
    dispatcher_.emit(IsPatternCastTypeReprsTrap{
        label, dispatcher_.fetchLabel(typeRepr, pattern->getCastType())});
  }
  if (auto subPattern = pattern->getSubPattern()) {
    dispatcher_.emit(IsPatternSubPatternsTrap{label, dispatcher_.fetchLabel(subPattern)});
  }
}

void PatternVisitor::visitExprPattern(swift::ExprPattern* pattern) {
  auto label = dispatcher_.assignNewLabel(pattern);
  assert(pattern->getSubExpr() && "expect ExprPattern to have SubExpr");
  dispatcher_.emit(ExprPatternsTrap{label, dispatcher_.fetchLabel(pattern->getSubExpr())});
}

void PatternVisitor::visitParenPattern(swift::ParenPattern* pattern) {
  auto label = dispatcher_.assignNewLabel(pattern);
  assert(pattern->getSubPattern() && "expect ParenPattern to have SubPattern");
  dispatcher_.emit(ParenPatternsTrap{label, dispatcher_.fetchLabel(pattern->getSubPattern())});
}

void PatternVisitor::visitBoolPattern(swift::BoolPattern* pattern) {
  auto label = dispatcher_.assignNewLabel(pattern);
  dispatcher_.emit(BoolPatternsTrap{label, pattern->getValue()});
}

}  // namespace codeql
