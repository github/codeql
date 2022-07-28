#include "swift/extractor/visitors/ExprVisitor.h"

#include <swift/AST/ParameterList.h>

namespace codeql {

template <typename DirectToStorage,
          typename DirectToImplementation,
          typename Ordinary,
          typename T,
          typename Label>
void ExprVisitor::emitAccessorSemantics(T* ast, Label label) {
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

void ExprVisitor::visit(swift::Expr* expr) {
  swift::ExprVisitor<ExprVisitor, void>::visit(expr);
  auto label = dispatcher_.fetchLabel(expr);
  if (auto type = expr->getType()) {
    dispatcher_.emit(ExprTypesTrap{label, dispatcher_.fetchLabel(type)});
  }
}

void ExprVisitor::visitIntegerLiteralExpr(swift::IntegerLiteralExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  auto value = (expr->isNegative() ? "-" : "") + expr->getDigitsText().str();
  dispatcher_.emit(IntegerLiteralExprsTrap{label, value});
}

void ExprVisitor::visitFloatLiteralExpr(swift::FloatLiteralExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  auto value = (expr->isNegative() ? "-" : "") + expr->getDigitsText().str();
  dispatcher_.emit(FloatLiteralExprsTrap{label, value});
}

void ExprVisitor::visitBooleanLiteralExpr(swift::BooleanLiteralExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(BooleanLiteralExprsTrap{label, expr->getValue()});
}

void ExprVisitor::visitMagicIdentifierLiteralExpr(swift::MagicIdentifierLiteralExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  auto kind = swift::MagicIdentifierLiteralExpr::getKindString(expr->getKind()).str();
  dispatcher_.emit(MagicIdentifierLiteralExprsTrap{label, kind});
}

void ExprVisitor::visitStringLiteralExpr(swift::StringLiteralExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(StringLiteralExprsTrap{label, expr->getValue().str()});
}

void ExprVisitor::visitInterpolatedStringLiteralExpr(swift::InterpolatedStringLiteralExpr* expr) {
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

void ExprVisitor::visitNilLiteralExpr(swift::NilLiteralExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(NilLiteralExprsTrap{label});
}

void ExprVisitor::visitCallExpr(swift::CallExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(CallExprsTrap{label});
  emitApplyExpr(expr, label);
}

void ExprVisitor::visitPrefixUnaryExpr(swift::PrefixUnaryExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(PrefixUnaryExprsTrap{label});
  emitApplyExpr(expr, label);
}

void ExprVisitor::visitDeclRefExpr(swift::DeclRefExpr* expr) {
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

void ExprVisitor::visitAssignExpr(swift::AssignExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  assert(expr->getDest() && "AssignExpr has Dest");
  assert(expr->getSrc() && "AssignExpr has Src");
  auto dest = dispatcher_.fetchLabel(expr->getDest());
  auto src = dispatcher_.fetchLabel(expr->getSrc());
  dispatcher_.emit(AssignExprsTrap{label, dest, src});
}

void ExprVisitor::visitBindOptionalExpr(swift::BindOptionalExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  assert(expr->getSubExpr() && "BindOptionalExpr has SubExpr");
  auto subExpr = dispatcher_.fetchLabel(expr->getSubExpr());
  dispatcher_.emit(BindOptionalExprsTrap{label, subExpr});
}

void ExprVisitor::visitCaptureListExpr(swift::CaptureListExpr* expr) {
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

void ExprVisitor::visitBinaryExpr(swift::BinaryExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(BinaryExprsTrap{label});
  emitApplyExpr(expr, label);
}

void ExprVisitor::visitTupleExpr(swift::TupleExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(TupleExprsTrap{label});
  unsigned index = 0;
  for (auto element : expr->getElements()) {
    auto elementLabel = dispatcher_.fetchLabel(element);
    dispatcher_.emit(TupleExprElementsTrap{label, index++, elementLabel});
  }
}

void ExprVisitor::visitDefaultArgumentExpr(swift::DefaultArgumentExpr* expr) {
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

void ExprVisitor::visitDotSyntaxBaseIgnoredExpr(swift::DotSyntaxBaseIgnoredExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  assert(expr->getLHS() && "DotSyntaxBaseIgnoredExpr has LHS");
  assert(expr->getRHS() && "DotSyntaxBaseIgnoredExpr has RHS");
  auto lhs = dispatcher_.fetchLabel(expr->getLHS());
  auto rhs = dispatcher_.fetchLabel(expr->getRHS());
  dispatcher_.emit(DotSyntaxBaseIgnoredExprsTrap{label, lhs, rhs});
}

void ExprVisitor::visitDynamicTypeExpr(swift::DynamicTypeExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  assert(expr->getBase() && "DynamicTypeExpr has Base");
  auto base = dispatcher_.fetchLabel(expr->getBase());
  dispatcher_.emit(DynamicTypeExprsTrap{label, base});
}

void ExprVisitor::visitEnumIsCaseExpr(swift::EnumIsCaseExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  assert(expr->getSubExpr() && "EnumIsCaseExpr has SubExpr");
  assert(expr->getCaseTypeRepr() && "EnumIsCaseExpr has CaseTypeRepr");
  assert(expr->getEnumElement() && "EnumIsCaseExpr has EnumElement");
  auto subExpr = dispatcher_.fetchLabel(expr->getSubExpr());
  auto enumElement = dispatcher_.fetchLabel(expr->getEnumElement());
  dispatcher_.emit(EnumIsCaseExprsTrap{label, subExpr, enumElement});
}

void ExprVisitor::visitMakeTemporarilyEscapableExpr(swift::MakeTemporarilyEscapableExpr* expr) {
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

void ExprVisitor::visitObjCSelectorExpr(swift::ObjCSelectorExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  assert(expr->getSubExpr() && "ObjCSelectorExpr has SubExpr");
  assert(expr->getMethod() && "ObjCSelectorExpr has Method");
  auto subExpr = dispatcher_.fetchLabel(expr->getSubExpr());
  auto method = dispatcher_.fetchLabel(expr->getMethod());
  dispatcher_.emit(ObjCSelectorExprsTrap{label, subExpr, method});
}

void ExprVisitor::visitOneWayExpr(swift::OneWayExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  assert(expr->getSubExpr() && "OneWayExpr has SubExpr");
  auto subExpr = dispatcher_.fetchLabel(expr->getSubExpr());
  dispatcher_.emit(OneWayExprsTrap{label, subExpr});
}

void ExprVisitor::visitOpenExistentialExpr(swift::OpenExistentialExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  assert(expr->getSubExpr() && "OpenExistentialExpr has SubExpr");
  assert(expr->getExistentialValue() && "OpenExistentialExpr has ExistentialValue");
  assert(expr->getOpaqueValue() && "OpenExistentialExpr has OpaqueValue");
  auto subExpr = dispatcher_.fetchLabel(expr->getSubExpr());
  auto existentialValue = dispatcher_.fetchLabel(expr->getExistentialValue());
  auto opaqueValue = dispatcher_.fetchLabel(expr->getOpaqueValue());
  dispatcher_.emit(OpenExistentialExprsTrap{label, subExpr, existentialValue, opaqueValue});
}

void ExprVisitor::visitOptionalEvaluationExpr(swift::OptionalEvaluationExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  assert(expr->getSubExpr() && "OptionalEvaluationExpr has SubExpr");
  auto subExpr = dispatcher_.fetchLabel(expr->getSubExpr());
  dispatcher_.emit(OptionalEvaluationExprsTrap{label, subExpr});
}

void ExprVisitor::visitRebindSelfInConstructorExpr(swift::RebindSelfInConstructorExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  assert(expr->getSubExpr() && "RebindSelfInConstructorExpr has SubExpr");
  assert(expr->getSelf() && "RebindSelfInConstructorExpr has Self");
  auto subExpr = dispatcher_.fetchLabel(expr->getSubExpr());
  auto self = dispatcher_.fetchLabel(expr->getSelf());
  dispatcher_.emit(RebindSelfInConstructorExprsTrap{label, subExpr, self});
}

void ExprVisitor::visitSuperRefExpr(swift::SuperRefExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  assert(expr->getSelf() && "SuperRefExpr has Self");
  auto self = dispatcher_.fetchLabel(expr->getSelf());
  dispatcher_.emit(SuperRefExprsTrap{label, self});
}

void ExprVisitor::visitDotSyntaxCallExpr(swift::DotSyntaxCallExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(DotSyntaxCallExprsTrap{label});
  emitSelfApplyExpr(expr, label);
}

void ExprVisitor::visitVarargExpansionExpr(swift::VarargExpansionExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  assert(expr->getSubExpr() && "VarargExpansionExpr has getSubExpr()");

  auto subExprLabel = dispatcher_.fetchLabel(expr->getSubExpr());
  dispatcher_.emit(VarargExpansionExprsTrap{label, subExprLabel});
}

void ExprVisitor::visitArrayExpr(swift::ArrayExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(ArrayExprsTrap{label});
  unsigned index = 0;
  for (auto element : expr->getElements()) {
    auto elementLabel = dispatcher_.fetchLabel(element);
    dispatcher_.emit(ArrayExprElementsTrap{label, index++, elementLabel});
  }
}

void ExprVisitor::visitErasureExpr(swift::ErasureExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(ErasureExprsTrap{label});
  emitImplicitConversionExpr(expr, label);
}

codeql::TypeExpr ExprVisitor::translateTypeExpr(const swift::TypeExpr& expr) {
  TypeExpr entry{dispatcher_.assignNewLabel(expr)};
  if (expr.getTypeRepr() && expr.getInstanceType()) {
    entry.type_repr = dispatcher_.fetchLabel(expr.getTypeRepr(), expr.getInstanceType());
  }
  return entry;
}

codeql::ParenExpr ExprVisitor::translateParenExpr(const swift::ParenExpr& expr) {
  ParenExpr entry{dispatcher_.assignNewLabel(expr)};
  fillIdentityExpr(expr, entry);
  return entry;
}

void ExprVisitor::visitLoadExpr(swift::LoadExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(LoadExprsTrap{label});
  emitImplicitConversionExpr(expr, label);
}

void ExprVisitor::visitInOutExpr(swift::InOutExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  assert(expr->getSubExpr() && "InOutExpr has getSubExpr()");

  auto subExprLabel = dispatcher_.fetchLabel(expr->getSubExpr());
  dispatcher_.emit(InOutExprsTrap{label, subExprLabel});
}

void ExprVisitor::visitOpaqueValueExpr(swift::OpaqueValueExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(OpaqueValueExprsTrap{label});
}

void ExprVisitor::visitTapExpr(swift::TapExpr* expr) {
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

void ExprVisitor::visitTupleElementExpr(swift::TupleElementExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  assert(expr->getBase() && "TupleElementExpr has getBase()");

  auto base = dispatcher_.fetchLabel(expr->getBase());
  auto index = expr->getFieldNumber();
  dispatcher_.emit(TupleElementExprsTrap{label, base, index});
}

void ExprVisitor::visitTryExpr(swift::TryExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(TryExprsTrap{label});
  emitAnyTryExpr(expr, label);
}

void ExprVisitor::visitForceTryExpr(swift::ForceTryExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(ForceTryExprsTrap{label});
  emitAnyTryExpr(expr, label);
}

void ExprVisitor::visitOptionalTryExpr(swift::OptionalTryExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(OptionalTryExprsTrap{label});
  emitAnyTryExpr(expr, label);
}

void ExprVisitor::visitInjectIntoOptionalExpr(swift::InjectIntoOptionalExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(InjectIntoOptionalExprsTrap{label});
  emitImplicitConversionExpr(expr, label);
}

void ExprVisitor::visitConstructorRefCallExpr(swift::ConstructorRefCallExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(ConstructorRefCallExprsTrap{label});
  emitSelfApplyExpr(expr, label);
}

void ExprVisitor::visitDiscardAssignmentExpr(swift::DiscardAssignmentExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(DiscardAssignmentExprsTrap{label});
}

codeql::ClosureExpr ExprVisitor::translateClosureExpr(const swift::ClosureExpr& expr) {
  ClosureExpr entry{dispatcher_.assignNewLabel(expr)};
  fillAbstractClosureExpr(expr, entry);
  return entry;
}

codeql::AutoClosureExpr ExprVisitor::translateAutoClosureExpr(const swift::AutoClosureExpr& expr) {
  AutoClosureExpr entry{dispatcher_.assignNewLabel(expr)};
  fillAbstractClosureExpr(expr, entry);
  return entry;
}

void ExprVisitor::visitCoerceExpr(swift::CoerceExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(CoerceExprsTrap{label});
  emitExplicitCastExpr(expr, label);
}

void ExprVisitor::visitConditionalCheckedCastExpr(swift::ConditionalCheckedCastExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(ConditionalCheckedCastExprsTrap{label});
  emitExplicitCastExpr(expr, label);
}

void ExprVisitor::visitForcedCheckedCastExpr(swift::ForcedCheckedCastExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(ForcedCheckedCastExprsTrap{label});
  emitExplicitCastExpr(expr, label);
}

void ExprVisitor::visitIsExpr(swift::IsExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(IsExprsTrap{label});
  emitExplicitCastExpr(expr, label);
}

void ExprVisitor::visitLookupExpr(swift::LookupExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  emitLookupExpr(expr, label);
}

void ExprVisitor::visitSubscriptExpr(swift::SubscriptExpr* expr) {
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

void ExprVisitor::visitDictionaryExpr(swift::DictionaryExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(DictionaryExprsTrap{label});
  unsigned index = 0;
  for (auto element : expr->getElements()) {
    auto elementLabel = dispatcher_.fetchLabel(element);
    dispatcher_.emit(DictionaryExprElementsTrap{label, index++, elementLabel});
  }
}

void ExprVisitor::visitFunctionConversionExpr(swift::FunctionConversionExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(FunctionConversionExprsTrap{label});
  emitImplicitConversionExpr(expr, label);
}

void ExprVisitor::visitInOutToPointerExpr(swift::InOutToPointerExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(InOutToPointerExprsTrap{label});
  emitImplicitConversionExpr(expr, label);
}

void ExprVisitor::visitMemberRefExpr(swift::MemberRefExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(MemberRefExprsTrap{label});

  emitAccessorSemantics<MemberRefExprHasDirectToStorageSemanticsTrap,
                        MemberRefExprHasDirectToImplementationSemanticsTrap,
                        MemberRefExprHasOrdinarySemanticsTrap>(expr, label);

  emitLookupExpr(expr, label);
}

void ExprVisitor::visitDerivedToBaseExpr(swift::DerivedToBaseExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(DerivedToBaseExprsTrap{label});
  emitImplicitConversionExpr(expr, label);
}

void ExprVisitor::visitKeyPathExpr(swift::KeyPathExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(KeyPathExprsTrap{label});
  if (!expr->isObjC()) {
    if (auto path = expr->getParsedPath()) {
      auto pathLabel = dispatcher_.fetchLabel(path);
      dispatcher_.emit(KeyPathExprParsedPathsTrap{label, pathLabel});
    }
    // TODO maybe move this logic to QL?
    if (auto rootTypeRepr = expr->getRootType()) {
      auto keyPathType = expr->getType()->getAs<swift::BoundGenericClassType>();
      assert(keyPathType && "KeyPathExpr must have BoundGenericClassType");
      auto keyPathTypeArgs = keyPathType->getGenericArgs();
      assert(keyPathTypeArgs.size() != 0 && "KeyPathExpr type must have generic args");
      auto rootLabel = dispatcher_.fetchLabel(rootTypeRepr, keyPathTypeArgs[0]);
      dispatcher_.emit(KeyPathExprRootsTrap{label, rootLabel});
    }
  }
}

void ExprVisitor::visitLazyInitializerExpr(swift::LazyInitializerExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  assert(expr->getSubExpr() && "LazyInitializerExpr has getSubExpr()");
  auto subExprLabel = dispatcher_.fetchLabel(expr->getSubExpr());
  dispatcher_.emit(LazyInitializerExprsTrap{label, subExprLabel});
}

void ExprVisitor::visitForceValueExpr(swift::ForceValueExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  assert(expr->getSubExpr() && "ForceValueExpr has getSubExpr()");

  auto subExprLabel = dispatcher_.fetchLabel(expr->getSubExpr());
  dispatcher_.emit(ForceValueExprsTrap{label, subExprLabel});
}

void ExprVisitor::visitPointerToPointerExpr(swift::PointerToPointerExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(PointerToPointerExprsTrap{label});
  emitImplicitConversionExpr(expr, label);
}

void ExprVisitor::visitIfExpr(swift::IfExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  assert(expr->getCondExpr() && "IfExpr has getCond()");
  assert(expr->getThenExpr() && "IfExpr has getThenExpr()");
  assert(expr->getElseExpr() && "IfExpr has getElseExpr()");

  auto condLabel = dispatcher_.fetchLabel(expr->getCondExpr());
  auto thenLabel = dispatcher_.fetchLabel(expr->getThenExpr());
  auto elseLabel = dispatcher_.fetchLabel(expr->getElseExpr());

  dispatcher_.emit(IfExprsTrap{label, condLabel, thenLabel, elseLabel});
}

void ExprVisitor::visitKeyPathDotExpr(swift::KeyPathDotExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  dispatcher_.emit(KeyPathDotExprsTrap{label});
}

void ExprVisitor::visitKeyPathApplicationExpr(swift::KeyPathApplicationExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  assert(expr->getBase() && "KeyPathApplicationExpr has getBase()");
  assert(expr->getKeyPath() && "KeyPathApplicationExpr has getKeyPath()");

  auto baseLabel = dispatcher_.fetchLabel(expr->getBase());
  auto keyPathLabel = dispatcher_.fetchLabel(expr->getKeyPath());

  dispatcher_.emit(KeyPathApplicationExprsTrap{label, baseLabel, keyPathLabel});
}

void ExprVisitor::visitOtherConstructorDeclRefExpr(swift::OtherConstructorDeclRefExpr* expr) {
  auto label = dispatcher_.assignNewLabel(expr);
  assert(expr->getDecl() && "OtherConstructorDeclRefExpr has getDecl()");

  auto ctorLabel = dispatcher_.fetchLabel(expr->getDecl());
  dispatcher_.emit(OtherConstructorDeclRefExprsTrap{label, ctorLabel});
}

codeql::UnresolvedDeclRefExpr ExprVisitor::translateUnresolvedDeclRefExpr(
    const swift::UnresolvedDeclRefExpr& expr) {
  codeql::UnresolvedDeclRefExpr entry{dispatcher_.assignNewLabel(expr)};
  if (expr.hasName()) {
    llvm::SmallVector<char> scratch;
    entry.name = expr.getName().getString(scratch).str();
  }
  return entry;
}

codeql::UnresolvedDotExpr ExprVisitor::translateUnresolvedDotExpr(
    const swift::UnresolvedDotExpr& expr) {
  codeql::UnresolvedDotExpr entry{dispatcher_.assignNewLabel(expr)};
  assert(expr.getBase() && "Expect UnresolvedDotExpr to have a base");
  entry.base = dispatcher_.fetchLabel(expr.getBase());
  llvm::SmallVector<char> scratch;
  entry.name = expr.getName().getString(scratch).str();
  return entry;
}

codeql::UnresolvedMemberExpr ExprVisitor::translateUnresolvedMemberExpr(
    const swift::UnresolvedMemberExpr& expr) {
  UnresolvedMemberExpr entry{dispatcher_.assignNewLabel(expr)};
  llvm::SmallVector<char> scratch;
  entry.name = expr.getName().getString(scratch).str();
  return entry;
}

codeql::SequenceExpr ExprVisitor::translateSequenceExpr(const swift::SequenceExpr& expr) {
  SequenceExpr entry{dispatcher_.assignNewLabel(expr)};
  entry.elements = dispatcher_.fetchRepeatedLabels(expr.getElements());
  return entry;
}

codeql::BridgeToObjCExpr ExprVisitor::translateBridgeToObjCExpr(
    const swift::BridgeToObjCExpr& expr) {
  BridgeToObjCExpr entry{dispatcher_.assignNewLabel(expr)};
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::BridgeFromObjCExpr ExprVisitor::translateBridgeFromObjCExpr(
    const swift::BridgeFromObjCExpr& expr) {
  BridgeFromObjCExpr entry{dispatcher_.assignNewLabel(expr)};
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::DotSelfExpr ExprVisitor::translateDotSelfExpr(const swift::DotSelfExpr& expr) {
  DotSelfExpr entry{dispatcher_.assignNewLabel(expr)};
  fillIdentityExpr(expr, entry);
  return entry;
}

codeql::ErrorExpr ExprVisitor::translateErrorExpr(const swift::ErrorExpr& expr) {
  ErrorExpr entry{dispatcher_.assignNewLabel(expr)};
  return entry;
}

void ExprVisitor::fillAbstractClosureExpr(const swift::AbstractClosureExpr& expr,
                                          codeql::AbstractClosureExpr& entry) {
  assert(expr.getParameters() && "AbstractClosureExpr has getParameters()");
  assert(expr.getBody() && "AbstractClosureExpr has getBody()");
  entry.params = dispatcher_.fetchRepeatedLabels(*expr.getParameters());
  entry.body = dispatcher_.fetchLabel(expr.getBody());
}

TrapLabel<ArgumentTag> ExprVisitor::emitArgument(const swift::Argument& arg) {
  auto entry = dispatcher_.createUncachedEntry(arg);
  entry.label = arg.getLabel().str().str();
  entry.expr = dispatcher_.fetchLabel(arg.getExpr());
  dispatcher_.emit(entry);
  return entry.id;
}

void ExprVisitor::emitImplicitConversionExpr(swift::ImplicitConversionExpr* expr,
                                             TrapLabel<ImplicitConversionExprTag> label) {
  assert(expr->getSubExpr() && "ImplicitConversionExpr has getSubExpr()");
  dispatcher_.emit(ImplicitConversionExprsTrap{label, dispatcher_.fetchLabel(expr->getSubExpr())});
}

void ExprVisitor::emitExplicitCastExpr(swift::ExplicitCastExpr* expr,
                                       TrapLabel<ExplicitCastExprTag> label) {
  assert(expr->getSubExpr() && "ExplicitCastExpr has getSubExpr()");
  dispatcher_.emit(ExplicitCastExprsTrap{label, dispatcher_.fetchLabel(expr->getSubExpr())});
}

void ExprVisitor::fillIdentityExpr(const swift::IdentityExpr& expr, codeql::IdentityExpr& entry) {
  assert(expr.getSubExpr() && "IdentityExpr has getSubExpr()");
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
}

void ExprVisitor::emitAnyTryExpr(swift::AnyTryExpr* expr, TrapLabel<AnyTryExprTag> label) {
  assert(expr->getSubExpr() && "AnyTryExpr has getSubExpr()");
  dispatcher_.emit(AnyTryExprsTrap{label, dispatcher_.fetchLabel(expr->getSubExpr())});
}

void ExprVisitor::emitApplyExpr(const swift::ApplyExpr* expr, TrapLabel<ApplyExprTag> label) {
  assert(expr->getFn() && "CallExpr has Fn");
  auto fnLabel = dispatcher_.fetchLabel(expr->getFn());
  dispatcher_.emit(ApplyExprsTrap{label, fnLabel});
  auto i = 0u;
  for (const auto& arg : *expr->getArgs()) {
    dispatcher_.emit(ApplyExprArgumentsTrap{label, i++, emitArgument(arg)});
  }
}

void ExprVisitor::emitSelfApplyExpr(const swift::SelfApplyExpr* expr,
                                    TrapLabel<SelfApplyExprTag> label) {
  assert(expr->getBase() && "SelfApplyExpr has getBase()");
  auto baseLabel = dispatcher_.fetchLabel(expr->getBase());
  dispatcher_.emit(SelfApplyExprsTrap{label, baseLabel});
  emitApplyExpr(expr, label);
}

void ExprVisitor::emitLookupExpr(const swift::LookupExpr* expr, TrapLabel<LookupExprTag> label) {
  assert(expr->getBase() && "LookupExpr has getBase()");
  auto baseLabel = dispatcher_.fetchLabel(expr->getBase());
  dispatcher_.emit(LookupExprsTrap{label, baseLabel});
  if (expr->hasDecl()) {
    auto declLabel = dispatcher_.fetchLabel(expr->getDecl().getDecl());
    dispatcher_.emit(LookupExprMembersTrap{label, declLabel});
  }
}

codeql::UnresolvedPatternExpr ExprVisitor::translateUnresolvedPatternExpr(
    swift::UnresolvedPatternExpr& expr) {
  auto entry = dispatcher_.createEntry(expr);
  entry.sub_pattern = dispatcher_.fetchLabel(expr.getSubPattern());
  return entry;
}
}  // namespace codeql
