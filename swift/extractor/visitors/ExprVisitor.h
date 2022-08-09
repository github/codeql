#pragma once

#include "swift/extractor/visitors/VisitorBase.h"
#include "swift/extractor/trap/generated/expr/TrapClasses.h"

namespace codeql {

class ExprVisitor : public AstVisitorBase<ExprVisitor> {
 public:
  using AstVisitorBase<ExprVisitor>::AstVisitorBase;

  void visit(swift::Expr* expr);
  void visitIntegerLiteralExpr(swift::IntegerLiteralExpr* expr);
  void visitFloatLiteralExpr(swift::FloatLiteralExpr* expr);
  void visitBooleanLiteralExpr(swift::BooleanLiteralExpr* expr);
  void visitMagicIdentifierLiteralExpr(swift::MagicIdentifierLiteralExpr* expr);
  void visitStringLiteralExpr(swift::StringLiteralExpr* expr);
  void visitInterpolatedStringLiteralExpr(swift::InterpolatedStringLiteralExpr* expr);
  void visitNilLiteralExpr(swift::NilLiteralExpr* expr);
  void visitCallExpr(swift::CallExpr* expr);
  void visitPrefixUnaryExpr(swift::PrefixUnaryExpr* expr);
  void visitDeclRefExpr(swift::DeclRefExpr* expr);
  void visitAssignExpr(swift::AssignExpr* expr);
  void visitBindOptionalExpr(swift::BindOptionalExpr* expr);
  void visitCaptureListExpr(swift::CaptureListExpr* expr);
  void visitBinaryExpr(swift::BinaryExpr* expr);
  void visitTupleExpr(swift::TupleExpr* expr);
  void visitDefaultArgumentExpr(swift::DefaultArgumentExpr* expr);
  void visitDotSyntaxBaseIgnoredExpr(swift::DotSyntaxBaseIgnoredExpr* expr);
  void visitDynamicTypeExpr(swift::DynamicTypeExpr* expr);
  void visitEnumIsCaseExpr(swift::EnumIsCaseExpr* expr);
  void visitMakeTemporarilyEscapableExpr(swift::MakeTemporarilyEscapableExpr* expr);
  void visitObjCSelectorExpr(swift::ObjCSelectorExpr* expr);
  void visitOneWayExpr(swift::OneWayExpr* expr);
  void visitOpenExistentialExpr(swift::OpenExistentialExpr* expr);
  void visitOptionalEvaluationExpr(swift::OptionalEvaluationExpr* expr);
  void visitRebindSelfInConstructorExpr(swift::RebindSelfInConstructorExpr* expr);
  void visitSuperRefExpr(swift::SuperRefExpr* expr);
  void visitDotSyntaxCallExpr(swift::DotSyntaxCallExpr* expr);
  void visitVarargExpansionExpr(swift::VarargExpansionExpr* expr);
  void visitArrayExpr(swift::ArrayExpr* expr);
  void visitErasureExpr(swift::ErasureExpr* expr);
  codeql::TypeExpr translateTypeExpr(const swift::TypeExpr& expr);
  codeql::ParenExpr translateParenExpr(const swift::ParenExpr& expr);
  void visitLoadExpr(swift::LoadExpr* expr);
  void visitInOutExpr(swift::InOutExpr* expr);
  void visitOpaqueValueExpr(swift::OpaqueValueExpr* expr);
  void visitTapExpr(swift::TapExpr* expr);
  void visitTupleElementExpr(swift::TupleElementExpr* expr);
  void visitTryExpr(swift::TryExpr* expr);
  void visitForceTryExpr(swift::ForceTryExpr* expr);
  void visitOptionalTryExpr(swift::OptionalTryExpr* expr);
  void visitInjectIntoOptionalExpr(swift::InjectIntoOptionalExpr* expr);
  void visitConstructorRefCallExpr(swift::ConstructorRefCallExpr* expr);
  void visitDiscardAssignmentExpr(swift::DiscardAssignmentExpr* expr);
  codeql::ClosureExpr translateClosureExpr(const swift::ClosureExpr& expr);
  codeql::AutoClosureExpr translateAutoClosureExpr(const swift::AutoClosureExpr& expr);
  void visitCoerceExpr(swift::CoerceExpr* expr);
  void visitConditionalCheckedCastExpr(swift::ConditionalCheckedCastExpr* expr);
  void visitForcedCheckedCastExpr(swift::ForcedCheckedCastExpr* expr);
  void visitIsExpr(swift::IsExpr* expr);
  void visitLookupExpr(swift::LookupExpr* expr);
  void visitSubscriptExpr(swift::SubscriptExpr* expr);
  void visitDictionaryExpr(swift::DictionaryExpr* expr);
  void visitFunctionConversionExpr(swift::FunctionConversionExpr* expr);
  void visitInOutToPointerExpr(swift::InOutToPointerExpr* expr);
  void visitMemberRefExpr(swift::MemberRefExpr* expr);
  void visitDerivedToBaseExpr(swift::DerivedToBaseExpr* expr);
  void visitKeyPathExpr(swift::KeyPathExpr* expr);
  void visitLazyInitializerExpr(swift::LazyInitializerExpr* expr);
  void visitForceValueExpr(swift::ForceValueExpr* expr);
  void visitPointerToPointerExpr(swift::PointerToPointerExpr* expr);
  void visitIfExpr(swift::IfExpr* expr);
  void visitKeyPathDotExpr(swift::KeyPathDotExpr* expr);
  void visitKeyPathApplicationExpr(swift::KeyPathApplicationExpr* expr);
  void visitOtherConstructorDeclRefExpr(swift::OtherConstructorDeclRefExpr* expr);
  codeql::UnresolvedDeclRefExpr translateUnresolvedDeclRefExpr(
      const swift::UnresolvedDeclRefExpr& expr);
  codeql::UnresolvedDotExpr translateUnresolvedDotExpr(const swift::UnresolvedDotExpr& expr);
  codeql::UnresolvedMemberExpr translateUnresolvedMemberExpr(
      const swift::UnresolvedMemberExpr& expr);
  codeql::SequenceExpr translateSequenceExpr(const swift::SequenceExpr& expr);
  codeql::BridgeToObjCExpr translateBridgeToObjCExpr(const swift::BridgeToObjCExpr& expr);
  codeql::BridgeFromObjCExpr translateBridgeFromObjCExpr(const swift::BridgeFromObjCExpr& expr);
  codeql::DotSelfExpr translateDotSelfExpr(const swift::DotSelfExpr& expr);
  codeql::ErrorExpr translateErrorExpr(const swift::ErrorExpr& expr);
  // The following function requires a non-const parameter because:
  // * `swift::UnresolvedPatternExpr::getSubPattern` has a `const`-qualified overload returning
  //   `const swift::Pattern*`
  // * `swift::ASTVisitor` only visits non-const pointers
  // either we accept this, or we fix constness, e.g. by providing `visit` on `const` pointers
  // in `VisitorBase`, or by doing a `const_cast` in `SwifDispatcher::fetchLabel`
  codeql::UnresolvedPatternExpr translateUnresolvedPatternExpr(swift::UnresolvedPatternExpr& expr);

 private:
  void fillAbstractClosureExpr(const swift::AbstractClosureExpr& expr,
                               codeql::AbstractClosureExpr& entry);
  TrapLabel<ArgumentTag> emitArgument(const swift::Argument& arg);
  void emitImplicitConversionExpr(swift::ImplicitConversionExpr* expr,
                                  TrapLabel<ImplicitConversionExprTag> label);
  void emitExplicitCastExpr(swift::ExplicitCastExpr* expr, TrapLabel<ExplicitCastExprTag> label);
  void fillIdentityExpr(const swift::IdentityExpr& expr, codeql::IdentityExpr& entry);
  void emitAnyTryExpr(swift::AnyTryExpr* expr, TrapLabel<AnyTryExprTag> label);
  void emitApplyExpr(const swift::ApplyExpr* expr, TrapLabel<ApplyExprTag> label);
  void emitSelfApplyExpr(const swift::SelfApplyExpr* expr, TrapLabel<SelfApplyExprTag> label);
  void emitLookupExpr(const swift::LookupExpr* expr, TrapLabel<LookupExprTag> label);

  /*
   * `DirectToStorage`, `DirectToImplementation`, and `DirectToImplementation` must be
   * constructable from a `Label` argument, and values of `T` must have a
   * `getAccessSemantics` member that returns a `swift::AccessSemantics`.
   */
  template <typename DirectToStorage,
            typename DirectToImplementation,
            typename Ordinary,
            typename T,
            typename Label>
  void emitAccessorSemantics(T* ast, Label label);
};

}  // namespace codeql
