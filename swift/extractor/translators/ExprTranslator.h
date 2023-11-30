#pragma once

#include "swift/extractor/translators/TranslatorBase.h"
#include "swift/extractor/trap/generated/expr/TrapClasses.h"

namespace codeql {

class ExprTranslator : public AstTranslatorBase<ExprTranslator> {
 public:
  static constexpr std::string_view name = "expr";

  using AstTranslatorBase<ExprTranslator>::AstTranslatorBase;

  codeql::IntegerLiteralExpr translateIntegerLiteralExpr(const swift::IntegerLiteralExpr& expr);
  codeql::FloatLiteralExpr translateFloatLiteralExpr(const swift::FloatLiteralExpr& expr);
  codeql::BooleanLiteralExpr translateBooleanLiteralExpr(const swift::BooleanLiteralExpr& expr);
  codeql::MagicIdentifierLiteralExpr translateMagicIdentifierLiteralExpr(
      const swift::MagicIdentifierLiteralExpr& expr);
  codeql::StringLiteralExpr translateStringLiteralExpr(const swift::StringLiteralExpr& expr);
  codeql::InterpolatedStringLiteralExpr translateInterpolatedStringLiteralExpr(
      const swift::InterpolatedStringLiteralExpr& expr);
  codeql::NilLiteralExpr translateNilLiteralExpr(const swift::NilLiteralExpr& expr);
  codeql::CallExpr translateCallExpr(const swift::CallExpr& expr);
  codeql::PrefixUnaryExpr translatePrefixUnaryExpr(const swift::PrefixUnaryExpr& expr);
  codeql::PostfixUnaryExpr translatePostfixUnaryExpr(const swift::PostfixUnaryExpr& expr);
  codeql::DeclRefExpr translateDeclRefExpr(const swift::DeclRefExpr& expr);
  codeql::AssignExpr translateAssignExpr(const swift::AssignExpr& expr);
  codeql::BindOptionalExpr translateBindOptionalExpr(const swift::BindOptionalExpr& expr);
  codeql::CaptureListExpr translateCaptureListExpr(const swift::CaptureListExpr& expr);
  codeql::BinaryExpr translateBinaryExpr(const swift::BinaryExpr& expr);
  codeql::TupleExpr translateTupleExpr(const swift::TupleExpr& expr);
  codeql::DefaultArgumentExpr translateDefaultArgumentExpr(const swift::DefaultArgumentExpr& expr);
  codeql::DotSyntaxBaseIgnoredExpr translateDotSyntaxBaseIgnoredExpr(
      const swift::DotSyntaxBaseIgnoredExpr& expr);
  codeql::DynamicTypeExpr translateDynamicTypeExpr(const swift::DynamicTypeExpr& expr);
  codeql::EnumIsCaseExpr translateEnumIsCaseExpr(const swift::EnumIsCaseExpr& expr);
  codeql::MakeTemporarilyEscapableExpr translateMakeTemporarilyEscapableExpr(
      const swift::MakeTemporarilyEscapableExpr& expr);
  codeql::ObjCSelectorExpr translateObjCSelectorExpr(const swift::ObjCSelectorExpr& expr);
  codeql::OneWayExpr translateOneWayExpr(const swift::OneWayExpr& expr);
  codeql::OpenExistentialExpr translateOpenExistentialExpr(const swift::OpenExistentialExpr& expr);
  codeql::OptionalEvaluationExpr translateOptionalEvaluationExpr(
      const swift::OptionalEvaluationExpr& expr);
  codeql::RebindSelfInInitializerExpr translateRebindSelfInConstructorExpr(
      const swift::RebindSelfInConstructorExpr& expr);
  codeql::SuperRefExpr translateSuperRefExpr(const swift::SuperRefExpr& expr);
  codeql::DotSyntaxCallExpr translateDotSyntaxCallExpr(const swift::DotSyntaxCallExpr& expr);
  codeql::VarargExpansionExpr translateVarargExpansionExpr(const swift::VarargExpansionExpr& expr);
  codeql::ArrayExpr translateArrayExpr(const swift::ArrayExpr& expr);

  template <typename E>
  TrapClassOf<E> translateImplicitConversionExpr(const E& expr) {
    auto entry = createExprEntry(expr);
    entry.sub_expr = dispatcher.fetchLabel(expr.getSubExpr());
    return entry;
  }

  codeql::TypeExpr translateTypeExpr(const swift::TypeExpr& expr);

  template <typename E>
  TrapClassOf<E> translateIdentityExpr(const E& expr) {
    auto entry = createExprEntry(expr);
    fillIdentityExpr(expr, entry);
    return entry;
  }

  codeql::InOutExpr translateInOutExpr(const swift::InOutExpr& expr);
  codeql::OpaqueValueExpr translateOpaqueValueExpr(const swift::OpaqueValueExpr& expr);
  codeql::TapExpr translateTapExpr(const swift::TapExpr& expr);
  codeql::TupleElementExpr translateTupleElementExpr(const swift::TupleElementExpr& expr);
  codeql::TryExpr translateTryExpr(const swift::TryExpr& expr);
  codeql::ForceTryExpr translateForceTryExpr(const swift::ForceTryExpr& expr);
  codeql::OptionalTryExpr translateOptionalTryExpr(const swift::OptionalTryExpr& expr);
  codeql::InitializerRefCallExpr translateConstructorRefCallExpr(
      const swift::ConstructorRefCallExpr& expr);
  codeql::DiscardAssignmentExpr translateDiscardAssignmentExpr(
      const swift::DiscardAssignmentExpr& expr);
  codeql::ExplicitClosureExpr translateClosureExpr(const swift::ClosureExpr& expr);
  codeql::AutoClosureExpr translateAutoClosureExpr(const swift::AutoClosureExpr& expr);
  codeql::CoerceExpr translateCoerceExpr(const swift::CoerceExpr& expr);
  codeql::ConditionalCheckedCastExpr translateConditionalCheckedCastExpr(
      const swift::ConditionalCheckedCastExpr& expr);
  codeql::ForcedCheckedCastExpr translateForcedCheckedCastExpr(
      const swift::ForcedCheckedCastExpr& expr);
  codeql::IsExpr translateIsExpr(const swift::IsExpr& expr);
  codeql::SubscriptExpr translateSubscriptExpr(const swift::SubscriptExpr& expr);
  codeql::DictionaryExpr translateDictionaryExpr(const swift::DictionaryExpr& expr);
  codeql::MemberRefExpr translateMemberRefExpr(const swift::MemberRefExpr& expr);
  codeql::KeyPathExpr translateKeyPathExpr(const swift::KeyPathExpr& expr);
  codeql::LazyInitializationExpr translateLazyInitializerExpr(
      const swift::LazyInitializerExpr& expr);
  codeql::ForceValueExpr translateForceValueExpr(const swift::ForceValueExpr& expr);
  codeql::IfExpr translateTernaryExpr(const swift::TernaryExpr& expr);
  codeql::KeyPathDotExpr translateKeyPathDotExpr(const swift::KeyPathDotExpr& expr);
  codeql::KeyPathApplicationExpr translateKeyPathApplicationExpr(
      const swift::KeyPathApplicationExpr& expr);
  codeql::OtherInitializerRefExpr translateOtherConstructorDeclRefExpr(
      const swift::OtherConstructorDeclRefExpr& expr);
  codeql::UnresolvedDeclRefExpr translateUnresolvedDeclRefExpr(
      const swift::UnresolvedDeclRefExpr& expr);
  codeql::UnresolvedDotExpr translateUnresolvedDotExpr(const swift::UnresolvedDotExpr& expr);
  codeql::UnresolvedMemberExpr translateUnresolvedMemberExpr(
      const swift::UnresolvedMemberExpr& expr);
  codeql::SequenceExpr translateSequenceExpr(const swift::SequenceExpr& expr);
  codeql::ErrorExpr translateErrorExpr(const swift::ErrorExpr& expr);
  codeql::UnresolvedPatternExpr translateUnresolvedPatternExpr(
      const swift::UnresolvedPatternExpr& expr);
  codeql::ObjectLiteralExpr translateObjectLiteralExpr(const swift::ObjectLiteralExpr& expr);
  codeql::OverloadedDeclRefExpr translateOverloadedDeclRefExpr(
      const swift::OverloadedDeclRefExpr& expr);
  codeql::DynamicMemberRefExpr translateDynamicMemberRefExpr(
      const swift::DynamicMemberRefExpr& expr);
  codeql::DynamicSubscriptExpr translateDynamicSubscriptExpr(
      const swift::DynamicSubscriptExpr& expr);
  codeql::UnresolvedSpecializeExpr translateUnresolvedSpecializeExpr(
      const swift::UnresolvedSpecializeExpr& expr);
  codeql::PropertyWrapperValuePlaceholderExpr translatePropertyWrapperValuePlaceholderExpr(
      const swift::PropertyWrapperValuePlaceholderExpr& expr);
  codeql::AppliedPropertyWrapperExpr translateAppliedPropertyWrapperExpr(
      const swift::AppliedPropertyWrapperExpr& expr);
  codeql::RegexLiteralExpr translateRegexLiteralExpr(const swift::RegexLiteralExpr& expr);
  codeql::SingleValueStmtExpr translateSingleValueStmtExpr(const swift::SingleValueStmtExpr& expr);
  codeql::PackExpansionExpr translatePackExpansionExpr(const swift::PackExpansionExpr& expr);
  codeql::PackElementExpr translatePackElementExpr(const swift::PackElementExpr& expr);
  codeql::CopyExpr translateCopyExpr(const swift::CopyExpr& expr);
  codeql::ConsumeExpr translateConsumeExpr(const swift::ConsumeExpr& expr);
  codeql::MaterializePackExpr translateMaterializePackExpr(const swift::MaterializePackExpr& expr);

 private:
  void fillClosureExpr(const swift::AbstractClosureExpr& expr, codeql::ClosureExpr& entry);
  TrapLabel<ArgumentTag> emitArgument(const swift::Argument& arg);
  TrapLabel<KeyPathComponentTag> emitKeyPathComponent(const swift::KeyPathExpr::Component& expr);
  void fillExplicitCastExpr(const swift::ExplicitCastExpr& expr, codeql::ExplicitCastExpr& entry);
  void fillIdentityExpr(const swift::IdentityExpr& expr, codeql::IdentityExpr& entry);
  void fillAnyTryExpr(const swift::AnyTryExpr& expr, codeql::AnyTryExpr& entry);
  void fillApplyExpr(const swift::ApplyExpr& expr, codeql::ApplyExpr& entry);
  void fillSelfApplyExpr(const swift::SelfApplyExpr& expr, codeql::SelfApplyExpr& entry);
  void fillLookupExpr(const swift::LookupExpr& expr, codeql::LookupExpr& entry);

  template <typename T>
  void fillAccessorSemantics(const T& ast, TrapClassOf<T>& entry);

  template <typename T>
  TrapClassOf<T> createExprEntry(const T& expr) {
    auto entry = dispatcher.createEntry(expr);
    entry.type = dispatcher.fetchOptionalLabel(expr.getType());
    return entry;
  }
};

}  // namespace codeql
