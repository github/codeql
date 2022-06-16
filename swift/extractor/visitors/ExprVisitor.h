#pragma once

#include "swift/extractor/visitors/VisitorBase.h"

namespace codeql {

class ExprVisitor : public AstVisitorBase<ExprVisitor> {
 public:
  using AstVisitorBase<ExprVisitor>::AstVisitorBase;

  void visit(swift::Expr* expr) {
    swift::ExprVisitor<ExprVisitor, void>::visit(expr);
    auto label = dispatcher_.fetchLabel(expr);
    if (auto type = expr->getType()) {
      dispatcher_.emit(ExprTypesTrap{label, dispatcher_.fetchLabel(type)});
    }
  }

  void visitIntegerLiteralExpr(swift::IntegerLiteralExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    auto value = (expr->isNegative() ? "-" : "") + expr->getDigitsText().str();
    dispatcher_.emit(IntegerLiteralExprsTrap{label, value});
  }

  void visitFloatLiteralExpr(swift::FloatLiteralExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    auto value = (expr->isNegative() ? "-" : "") + expr->getDigitsText().str();
    dispatcher_.emit(FloatLiteralExprsTrap{label, value});
  }

  void visitBooleanLiteralExpr(swift::BooleanLiteralExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(BooleanLiteralExprsTrap{label, expr->getValue()});
  }

  void visitMagicIdentifierLiteralExpr(swift::MagicIdentifierLiteralExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    auto kind = swift::MagicIdentifierLiteralExpr::getKindString(expr->getKind()).str();
    dispatcher_.emit(MagicIdentifierLiteralExprsTrap{label, kind});
  }

  void visitStringLiteralExpr(swift::StringLiteralExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(StringLiteralExprsTrap{label, expr->getValue().str()});
  }

  void visitInterpolatedStringLiteralExpr(swift::InterpolatedStringLiteralExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(InterpolatedStringLiteralExprsTrap{label});
    if (auto interpolation = expr->getInterpolationExpr()) {
      auto ref = dispatcher_.fetchLabel(interpolation);
      dispatcher_.emit(InterpolatedStringLiteralExprInterpolationExprsTrap{label, ref});
    }
    if (auto count = expr->getInterpolationCountExpr()) {
      auto ref = dispatcher_.fetchLabel(count);
      dispatcher_.emit(InterpolatedStringLiteralExprInterpolationCountExprsTrap{label, ref});
    }
    if (auto capacity = expr->getLiteralCapacityExpr()) {
      auto ref = dispatcher_.fetchLabel(capacity);
      dispatcher_.emit(InterpolatedStringLiteralExprLiteralCapacityExprsTrap{label, ref});
    }
    if (auto appending = expr->getAppendingExpr()) {
      auto ref = dispatcher_.fetchLabel(appending);
      dispatcher_.emit(InterpolatedStringLiteralExprAppendingExprsTrap{label, ref});
    }
  }

  void visitNilLiteralExpr(swift::NilLiteralExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(NilLiteralExprsTrap{label});
  }

  void visitCallExpr(swift::CallExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(CallExprsTrap{label});
    emitApplyExpr(expr, label);
  }

  void visitPrefixUnaryExpr(swift::PrefixUnaryExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(PrefixUnaryExprsTrap{label});
    emitApplyExpr(expr, label);
  }

  void visitDeclRefExpr(swift::DeclRefExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(DeclRefExprsTrap{label, dispatcher_.fetchLabel(expr->getDecl())});
    emitAccessorSemantics<DeclRefExprHasDirectToStorageSemanticsTrap,
                          DeclRefExprHasDirectToImplementationSemanticsTrap,
                          DeclRefExprHasOrdinarySemanticsTrap>(expr, label);
    auto i = 0u;
    for (auto t : expr->getDeclRef().getSubstitutions().getReplacementTypes()) {
      dispatcher_.emit(DeclRefExprReplacementTypesTrap{label, i++, dispatcher_.fetchLabel(t)});
    }
  }

  void visitAssignExpr(swift::AssignExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getDest() && "AssignExpr has Dest");
    assert(expr->getSrc() && "AssignExpr has Src");
    auto dest = dispatcher_.fetchLabel(expr->getDest());
    auto src = dispatcher_.fetchLabel(expr->getSrc());
    dispatcher_.emit(AssignExprsTrap{label, dest, src});
  }

  void visitBindOptionalExpr(swift::BindOptionalExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getSubExpr() && "BindOptionalExpr has SubExpr");
    auto subExpr = dispatcher_.fetchLabel(expr->getSubExpr());
    dispatcher_.emit(BindOptionalExprsTrap{label, subExpr});
  }

  void visitCaptureListExpr(swift::CaptureListExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getClosureBody() && "CaptureListExpr has ClosureBody");
    auto closureBody = dispatcher_.fetchLabel(expr->getClosureBody());
    dispatcher_.emit(CaptureListExprsTrap{label, closureBody});
    unsigned index = 0;
    for (auto& entry : expr->getCaptureList()) {
      auto captureLabel = dispatcher_.fetchLabel(entry.PBD);
      dispatcher_.emit(CaptureListExprBindingDeclsTrap{label, index++, captureLabel});
    }
  }

  void visitBinaryExpr(swift::BinaryExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(BinaryExprsTrap{label});
    emitApplyExpr(expr, label);
  }

  void visitTupleExpr(swift::TupleExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(TupleExprsTrap{label});
    unsigned index = 0;
    for (auto element : expr->getElements()) {
      auto elementLabel = dispatcher_.fetchLabel(element);
      dispatcher_.emit(TupleExprElementsTrap{label, index++, elementLabel});
    }
  }

  void visitDefaultArgumentExpr(swift::DefaultArgumentExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getParamDecl() && "DefaultArgumentExpr has getParamDecl");
    /// TODO: suddenly, getParamDecl is const, monkey-patching it here
    auto paramLabel = dispatcher_.fetchLabel((swift::ParamDecl*)expr->getParamDecl());
    dispatcher_.emit(
        DefaultArgumentExprsTrap{label, paramLabel, static_cast<int>(expr->getParamIndex())});
    if (expr->isCallerSide()) {
      auto callSiteDefaultLabel = dispatcher_.fetchLabel(expr->getCallerSideDefaultExpr());
      dispatcher_.emit(DefaultArgumentExprCallerSideDefaultsTrap{label, callSiteDefaultLabel});
    }
  }

  void visitDotSyntaxBaseIgnoredExpr(swift::DotSyntaxBaseIgnoredExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getLHS() && "DotSyntaxBaseIgnoredExpr has LHS");
    assert(expr->getRHS() && "DotSyntaxBaseIgnoredExpr has RHS");
    auto lhs = dispatcher_.fetchLabel(expr->getLHS());
    auto rhs = dispatcher_.fetchLabel(expr->getRHS());
    dispatcher_.emit(DotSyntaxBaseIgnoredExprsTrap{label, lhs, rhs});
  }

  void visitDynamicTypeExpr(swift::DynamicTypeExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getBase() && "DynamicTypeExpr has Base");
    auto base = dispatcher_.fetchLabel(expr->getBase());
    dispatcher_.emit(DynamicTypeExprsTrap{label, base});
  }

  void visitEnumIsCaseExpr(swift::EnumIsCaseExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getSubExpr() && "EnumIsCaseExpr has SubExpr");
    assert(expr->getCaseTypeRepr() && "EnumIsCaseExpr has CaseTypeRepr");
    assert(expr->getEnumElement() && "EnumIsCaseExpr has EnumElement");
    auto subExpr = dispatcher_.fetchLabel(expr->getSubExpr());
    auto typeRepr = dispatcher_.fetchLabel(expr->getCaseTypeRepr());
    auto enumElement = dispatcher_.fetchLabel(expr->getEnumElement());
    dispatcher_.emit(EnumIsCaseExprsTrap{label, subExpr, typeRepr, enumElement});
  }

  void visitMakeTemporarilyEscapableExpr(swift::MakeTemporarilyEscapableExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getOpaqueValue() && "MakeTemporarilyEscapableExpr has OpaqueValue");
    assert(expr->getNonescapingClosureValue() &&
           "MakeTemporarilyEscapableExpr has NonescapingClosureValue");
    assert(expr->getSubExpr() && "MakeTemporarilyEscapableExpr has SubExpr");
    auto opaqueValue = dispatcher_.fetchLabel(expr->getOpaqueValue());
    auto nonescapingClosureValue = dispatcher_.fetchLabel(expr->getNonescapingClosureValue());
    auto subExpr = dispatcher_.fetchLabel(expr->getSubExpr());
    dispatcher_.emit(
        MakeTemporarilyEscapableExprsTrap{label, opaqueValue, nonescapingClosureValue, subExpr});
  }

  void visitObjCSelectorExpr(swift::ObjCSelectorExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getSubExpr() && "ObjCSelectorExpr has SubExpr");
    assert(expr->getMethod() && "ObjCSelectorExpr has Method");
    auto subExpr = dispatcher_.fetchLabel(expr->getSubExpr());
    auto method = dispatcher_.fetchLabel(expr->getMethod());
    dispatcher_.emit(ObjCSelectorExprsTrap{label, subExpr, method});
  }

  void visitOneWayExpr(swift::OneWayExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getSubExpr() && "OneWayExpr has SubExpr");
    auto subExpr = dispatcher_.fetchLabel(expr->getSubExpr());
    dispatcher_.emit(OneWayExprsTrap{label, subExpr});
  }

  void visitOpenExistentialExpr(swift::OpenExistentialExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getSubExpr() && "OpenExistentialExpr has SubExpr");
    assert(expr->getExistentialValue() && "OpenExistentialExpr has ExistentialValue");
    assert(expr->getOpaqueValue() && "OpenExistentialExpr has OpaqueValue");
    auto subExpr = dispatcher_.fetchLabel(expr->getSubExpr());
    auto existentialValue = dispatcher_.fetchLabel(expr->getExistentialValue());
    auto opaqueValue = dispatcher_.fetchLabel(expr->getOpaqueValue());
    dispatcher_.emit(OpenExistentialExprsTrap{label, subExpr, existentialValue, opaqueValue});
  }

  void visitOptionalEvaluationExpr(swift::OptionalEvaluationExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getSubExpr() && "OptionalEvaluationExpr has SubExpr");
    auto subExpr = dispatcher_.fetchLabel(expr->getSubExpr());
    dispatcher_.emit(OptionalEvaluationExprsTrap{label, subExpr});
  }

  void visitRebindSelfInConstructorExpr(swift::RebindSelfInConstructorExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getSubExpr() && "RebindSelfInConstructorExpr has SubExpr");
    assert(expr->getSelf() && "RebindSelfInConstructorExpr has Self");
    auto subExpr = dispatcher_.fetchLabel(expr->getSubExpr());
    auto self = dispatcher_.fetchLabel(expr->getSelf());
    dispatcher_.emit(RebindSelfInConstructorExprsTrap{label, subExpr, self});
  }

  void visitSuperRefExpr(swift::SuperRefExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getSelf() && "SuperRefExpr has Self");
    auto self = dispatcher_.fetchLabel(expr->getSelf());
    dispatcher_.emit(SuperRefExprsTrap{label, self});
  }

  void visitDotSyntaxCallExpr(swift::DotSyntaxCallExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(DotSyntaxCallExprsTrap{label});
    emitSelfApplyExpr(expr, label);
  }

  void visitVarargExpansionExpr(swift::VarargExpansionExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getSubExpr() && "VarargExpansionExpr has getSubExpr()");

    auto subExprLabel = dispatcher_.fetchLabel(expr->getSubExpr());
    dispatcher_.emit(VarargExpansionExprsTrap{label, subExprLabel});
  }

  void visitArrayExpr(swift::ArrayExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(ArrayExprsTrap{label});
    unsigned index = 0;
    for (auto element : expr->getElements()) {
      auto elementLabel = dispatcher_.fetchLabel(element);
      dispatcher_.emit(ArrayExprElementsTrap{label, index++, elementLabel});
    }
  }

  void visitErasureExpr(swift::ErasureExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(ErasureExprsTrap{label});
    emitImplicitConversionExpr(expr, label);
  }

  void visitTypeExpr(swift::TypeExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(TypeExprsTrap{label});
    if (auto repr = expr->getTypeRepr()) {
      auto typeLabel = dispatcher_.fetchLabel(repr);
      dispatcher_.emit(TypeExprTypeReprsTrap{label, typeLabel});
    }
  }

  void visitParenExpr(swift::ParenExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(ParenExprsTrap{label});
    emitIdentityExpr(expr, label);
  }

  void visitLoadExpr(swift::LoadExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(LoadExprsTrap{label});
    emitImplicitConversionExpr(expr, label);
  }

  void visitInOutExpr(swift::InOutExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getSubExpr() && "InOutExpr has getSubExpr()");

    auto subExprLabel = dispatcher_.fetchLabel(expr->getSubExpr());
    dispatcher_.emit(InOutExprsTrap{label, subExprLabel});
  }

  void visitOpaqueValueExpr(swift::OpaqueValueExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(OpaqueValueExprsTrap{label});
  }

  void visitTapExpr(swift::TapExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getVar() && "TapExpr has getVar()");
    assert(expr->getBody() && "TapExpr has getBody()");

    auto varLabel = dispatcher_.fetchLabel(expr->getVar());
    auto bodyLabel = dispatcher_.fetchLabel(expr->getBody());

    dispatcher_.emit(TapExprsTrap{label, bodyLabel, varLabel});
    if (auto subExpr = expr->getSubExpr()) {
      dispatcher_.emit(TapExprSubExprsTrap{label, dispatcher_.fetchLabel(subExpr)});
    }
  }

  void visitTupleElementExpr(swift::TupleElementExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getBase() && "TupleElementExpr has getBase()");

    auto base = dispatcher_.fetchLabel(expr->getBase());
    auto index = expr->getFieldNumber();
    dispatcher_.emit(TupleElementExprsTrap{label, base, index});
  }

  void visitTryExpr(swift::TryExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(TryExprsTrap{label});
    emitAnyTryExpr(expr, label);
  }

  void visitForceTryExpr(swift::ForceTryExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(ForceTryExprsTrap{label});
    emitAnyTryExpr(expr, label);
  }

  void visitOptionalTryExpr(swift::OptionalTryExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(OptionalTryExprsTrap{label});
    emitAnyTryExpr(expr, label);
  }

  void visitInjectIntoOptionalExpr(swift::InjectIntoOptionalExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(InjectIntoOptionalExprsTrap{label});
    emitImplicitConversionExpr(expr, label);
  }

  void visitConstructorRefCallExpr(swift::ConstructorRefCallExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(ConstructorRefCallExprsTrap{label});
    emitSelfApplyExpr(expr, label);
  }

  void visitDiscardAssignmentExpr(swift::DiscardAssignmentExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(DiscardAssignmentExprsTrap{label});
  }

  void visitClosureExpr(swift::ClosureExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getBody() && "ClosureExpr has getBody()");
    auto bodyLabel = dispatcher_.fetchLabel(expr->getBody());
    dispatcher_.emit(ClosureExprsTrap{label, bodyLabel});
    emitAbstractClosureExpr(expr, label);
  }

  void visitAutoClosureExpr(swift::AutoClosureExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getBody() && "AutoClosureExpr has getBody()");
    auto bodyLabel = dispatcher_.fetchLabel(expr->getBody());
    dispatcher_.emit(AutoClosureExprsTrap{label, bodyLabel});
    emitAbstractClosureExpr(expr, label);
  }

  void visitCoerceExpr(swift::CoerceExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(CoerceExprsTrap{label});
    emitExplicitCastExpr(expr, label);
  }

  void visitConditionalCheckedCastExpr(swift::ConditionalCheckedCastExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(ConditionalCheckedCastExprsTrap{label});
    emitExplicitCastExpr(expr, label);
  }

  void visitForcedCheckedCastExpr(swift::ForcedCheckedCastExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(ForcedCheckedCastExprsTrap{label});
    emitExplicitCastExpr(expr, label);
  }

  void visitIsExpr(swift::IsExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(IsExprsTrap{label});
    emitExplicitCastExpr(expr, label);
  }

  void visitLookupExpr(swift::LookupExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    emitLookupExpr(expr, label);
  }

  void visitSubscriptExpr(swift::SubscriptExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(SubscriptExprsTrap{label});

    emitAccessorSemantics<SubscriptExprHasDirectToStorageSemanticsTrap,
                          SubscriptExprHasDirectToImplementationSemanticsTrap,
                          SubscriptExprHasOrdinarySemanticsTrap>(expr, label);

    auto i = 0u;
    for (const auto& arg : *expr->getArgs()) {
      dispatcher_.emit(SubscriptExprArgumentsTrap{label, i++, emitArgument(arg)});
    }
    emitLookupExpr(expr, label);
  }

  void visitDictionaryExpr(swift::DictionaryExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(DictionaryExprsTrap{label});
    unsigned index = 0;
    for (auto element : expr->getElements()) {
      auto elementLabel = dispatcher_.fetchLabel(element);
      dispatcher_.emit(DictionaryExprElementsTrap{label, index++, elementLabel});
    }
  }

  void visitFunctionConversionExpr(swift::FunctionConversionExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(FunctionConversionExprsTrap{label});
    emitImplicitConversionExpr(expr, label);
  }

  void visitInOutToPointerExpr(swift::InOutToPointerExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(InOutToPointerExprsTrap{label});
    emitImplicitConversionExpr(expr, label);
  }

  void visitMemberRefExpr(swift::MemberRefExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(MemberRefExprsTrap{label});

    emitAccessorSemantics<MemberRefExprHasDirectToStorageSemanticsTrap,
                          MemberRefExprHasDirectToImplementationSemanticsTrap,
                          MemberRefExprHasOrdinarySemanticsTrap>(expr, label);

    emitLookupExpr(expr, label);
  }

  void visitDerivedToBaseExpr(swift::DerivedToBaseExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(DerivedToBaseExprsTrap{label});
    emitImplicitConversionExpr(expr, label);
  }

  void visitKeyPathExpr(swift::KeyPathExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(KeyPathExprsTrap{label});
    if (!expr->isObjC()) {
      if (auto path = expr->getParsedPath()) {
        auto pathLabel = dispatcher_.fetchLabel(path);
        dispatcher_.emit(KeyPathExprParsedPathsTrap{label, pathLabel});
      }
      if (auto root = expr->getParsedRoot()) {
        auto rootLabel = dispatcher_.fetchLabel(root);
        dispatcher_.emit(KeyPathExprParsedRootsTrap{label, rootLabel});
      }
    }
  }

  void visitLazyInitializerExpr(swift::LazyInitializerExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getSubExpr() && "LazyInitializerExpr has getSubExpr()");
    auto subExprLabel = dispatcher_.fetchLabel(expr->getSubExpr());
    dispatcher_.emit(LazyInitializerExprsTrap{label, subExprLabel});
  }

  void visitForceValueExpr(swift::ForceValueExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getSubExpr() && "ForceValueExpr has getSubExpr()");

    auto subExprLabel = dispatcher_.fetchLabel(expr->getSubExpr());
    dispatcher_.emit(ForceValueExprsTrap{label, subExprLabel});
  }

  void visitPointerToPointerExpr(swift::PointerToPointerExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(PointerToPointerExprsTrap{label});
    emitImplicitConversionExpr(expr, label);
  }

  void visitIfExpr(swift::IfExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getCondExpr() && "IfExpr has getCond()");
    assert(expr->getThenExpr() && "IfExpr has getThenExpr()");
    assert(expr->getElseExpr() && "IfExpr has getElseExpr()");

    auto condLabel = dispatcher_.fetchLabel(expr->getCondExpr());
    auto thenLabel = dispatcher_.fetchLabel(expr->getThenExpr());
    auto elseLabel = dispatcher_.fetchLabel(expr->getElseExpr());

    dispatcher_.emit(IfExprsTrap{label, condLabel, thenLabel, elseLabel});
  }

  void visitKeyPathDotExpr(swift::KeyPathDotExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    dispatcher_.emit(KeyPathDotExprsTrap{label});
  }

  void visitKeyPathApplicationExpr(swift::KeyPathApplicationExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getBase() && "KeyPathApplicationExpr has getBase()");
    assert(expr->getKeyPath() && "KeyPathApplicationExpr has getKeyPath()");

    auto baseLabel = dispatcher_.fetchLabel(expr->getBase());
    auto keyPathLabel = dispatcher_.fetchLabel(expr->getKeyPath());

    dispatcher_.emit(KeyPathApplicationExprsTrap{label, baseLabel, keyPathLabel});
  }

  void visitOtherConstructorDeclRefExpr(swift::OtherConstructorDeclRefExpr* expr) {
    auto label = dispatcher_.assignNewLabel(expr);
    assert(expr->getDecl() && "OtherConstructorDeclRefExpr has getDecl()");

    auto ctorLabel = dispatcher_.fetchLabel(expr->getDecl());
    dispatcher_.emit(OtherConstructorDeclRefExprsTrap{label, ctorLabel});
  }

 private:
  void emitAbstractClosureExpr(swift::AbstractClosureExpr* expr,
                               TrapLabel<AbstractClosureExprTag> label) {
    assert(expr->getParameters() && "AbstractClosureExpr has getParameters()");
    auto params = expr->getParameters();
    for (auto i = 0u; i < params->size(); ++i) {
      dispatcher_.emit(
          AbstractClosureExprParamsTrap{label, i, dispatcher_.fetchLabel(params->get(i))});
    }
  }

  TrapLabel<ArgumentTag> emitArgument(const swift::Argument& arg) {
    auto argLabel = dispatcher_.createLabel<ArgumentTag>();
    assert(arg.getExpr() && "Argument has getExpr");
    dispatcher_.emit(
        ArgumentsTrap{argLabel, arg.getLabel().str().str(), dispatcher_.fetchLabel(arg.getExpr())});
    return argLabel;
  }

  void emitImplicitConversionExpr(swift::ImplicitConversionExpr* expr,
                                  TrapLabel<ImplicitConversionExprTag> label) {
    assert(expr->getSubExpr() && "ImplicitConversionExpr has getSubExpr()");
    dispatcher_.emit(
        ImplicitConversionExprsTrap{label, dispatcher_.fetchLabel(expr->getSubExpr())});
  }

  void emitExplicitCastExpr(swift::ExplicitCastExpr* expr, TrapLabel<ExplicitCastExprTag> label) {
    assert(expr->getSubExpr() && "ExplicitCastExpr has getSubExpr()");
    dispatcher_.emit(ExplicitCastExprsTrap{label, dispatcher_.fetchLabel(expr->getSubExpr())});
  }

  void emitIdentityExpr(swift::IdentityExpr* expr, TrapLabel<IdentityExprTag> label) {
    assert(expr->getSubExpr() && "IdentityExpr has getSubExpr()");
    dispatcher_.emit(IdentityExprsTrap{label, dispatcher_.fetchLabel(expr->getSubExpr())});
  }

  void emitAnyTryExpr(swift::AnyTryExpr* expr, TrapLabel<AnyTryExprTag> label) {
    assert(expr->getSubExpr() && "AnyTryExpr has getSubExpr()");
    dispatcher_.emit(AnyTryExprsTrap{label, dispatcher_.fetchLabel(expr->getSubExpr())});
  }

  void emitApplyExpr(const swift::ApplyExpr* expr, TrapLabel<ApplyExprTag> label) {
    assert(expr->getFn() && "CallExpr has Fn");
    auto fnLabel = dispatcher_.fetchLabel(expr->getFn());
    dispatcher_.emit(ApplyExprsTrap{label, fnLabel});
    auto i = 0u;
    for (const auto& arg : *expr->getArgs()) {
      dispatcher_.emit(ApplyExprArgumentsTrap{label, i++, emitArgument(arg)});
    }
  }

  void emitSelfApplyExpr(const swift::SelfApplyExpr* expr, TrapLabel<SelfApplyExprTag> label) {
    assert(expr->getBase() && "SelfApplyExpr has getBase()");
    auto baseLabel = dispatcher_.fetchLabel(expr->getBase());
    dispatcher_.emit(SelfApplyExprsTrap{label, baseLabel});
    emitApplyExpr(expr, label);
  }

  void emitLookupExpr(const swift::LookupExpr* expr, TrapLabel<LookupExprTag> label) {
    assert(expr->getBase() && "LookupExpr has getBase()");
    auto baseLabel = dispatcher_.fetchLabel(expr->getBase());
    assert(expr->hasDecl() && "LookupExpr has decl");
    auto declLabel = dispatcher_.fetchLabel(expr->getDecl().getDecl());
    dispatcher_.emit(LookupExprsTrap{label, baseLabel, declLabel});
  }

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
  void emitAccessorSemantics(T* ast, Label label) {
    switch (ast->getAccessSemantics()) {
      case swift::AccessSemantics::DirectToStorage:
        dispatcher_.emit(DirectToStorage{label});
        break;
      case swift::AccessSemantics::DirectToImplementation:
        dispatcher_.emit(DirectToImplementation{label});
        break;
      case swift::AccessSemantics::Ordinary:
        dispatcher_.emit(Ordinary{label});
        break;
    }
  }
};

}  // namespace codeql
