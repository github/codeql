#include "swift/extractor/visitors/ExprVisitor.h"

#include <swift/AST/ParameterList.h>

namespace codeql {

template <typename T>
void ExprVisitor::fillAccessorSemantics(const T& ast, TrapClassOf<T>& entry) {
  switch (ast.getAccessSemantics()) {
    case swift::AccessSemantics::DirectToStorage:
      entry.has_direct_to_storage_semantics = true;
      break;
    case swift::AccessSemantics::DirectToImplementation:
      entry.has_direct_to_implementation_semantics = true;
      break;
    case swift::AccessSemantics::Ordinary:
      entry.has_ordinary_semantics = true;
      break;
  }
}

codeql::IntegerLiteralExpr ExprVisitor::translateIntegerLiteralExpr(
    const swift::IntegerLiteralExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.string_value = (expr.isNegative() ? "-" : "") + expr.getDigitsText().str();
  return entry;
}

codeql::FloatLiteralExpr ExprVisitor::translateFloatLiteralExpr(
    const swift::FloatLiteralExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.string_value = (expr.isNegative() ? "-" : "") + expr.getDigitsText().str();
  return entry;
}

codeql::BooleanLiteralExpr ExprVisitor::translateBooleanLiteralExpr(
    const swift::BooleanLiteralExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.value = expr.getValue();
  return entry;
}

codeql::MagicIdentifierLiteralExpr ExprVisitor::translateMagicIdentifierLiteralExpr(
    const swift::MagicIdentifierLiteralExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.kind = swift::MagicIdentifierLiteralExpr::getKindString(expr.getKind()).str();
  return entry;
}

codeql::StringLiteralExpr ExprVisitor::translateStringLiteralExpr(
    const swift::StringLiteralExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.value = expr.getValue().str();
  return entry;
}

codeql::InterpolatedStringLiteralExpr ExprVisitor::translateInterpolatedStringLiteralExpr(
    const swift::InterpolatedStringLiteralExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.interpolation_expr = dispatcher_.fetchOptionalLabel(expr.getInterpolationExpr());
  // TODO we should be extracting getInterpolationCount and getLiteralCapacity directly to ints
  // these expressions here are just an internal thing, the ints are actually directly available
  entry.interpolation_count_expr = dispatcher_.fetchOptionalLabel(expr.getInterpolationCountExpr());
  entry.literal_capacity_expr = dispatcher_.fetchOptionalLabel(expr.getLiteralCapacityExpr());
  entry.appending_expr = dispatcher_.fetchOptionalLabel(expr.getAppendingExpr());
  return entry;
}

codeql::NilLiteralExpr ExprVisitor::translateNilLiteralExpr(const swift::NilLiteralExpr& expr) {
  auto entry = createExprEntry(expr);
  return entry;
}

codeql::CallExpr ExprVisitor::translateCallExpr(const swift::CallExpr& expr) {
  auto entry = createExprEntry(expr);
  fillApplyExpr(expr, entry);
  return entry;
}

codeql::PrefixUnaryExpr ExprVisitor::translatePrefixUnaryExpr(const swift::PrefixUnaryExpr& expr) {
  auto entry = createExprEntry(expr);
  fillApplyExpr(expr, entry);
  return entry;
}

codeql::DeclRefExpr ExprVisitor::translateDeclRefExpr(const swift::DeclRefExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.decl = dispatcher_.fetchLabel(expr.getDecl());
  fillAccessorSemantics(expr, entry);
  entry.replacement_types =
      dispatcher_.fetchRepeatedLabels(expr.getDeclRef().getSubstitutions().getReplacementTypes());
  return entry;
}

codeql::AssignExpr ExprVisitor::translateAssignExpr(const swift::AssignExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.dest = dispatcher_.fetchLabel(expr.getDest());
  entry.source = dispatcher_.fetchLabel(expr.getSrc());
  return entry;
}

codeql::BindOptionalExpr ExprVisitor::translateBindOptionalExpr(
    const swift::BindOptionalExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::CaptureListExpr ExprVisitor::translateCaptureListExpr(const swift::CaptureListExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.closure_body = dispatcher_.fetchLabel(expr.getClosureBody());
  for (const auto& item : const_cast<swift::CaptureListExpr&>(expr).getCaptureList()) {
    entry.binding_decls.push_back(dispatcher_.fetchLabel(item.PBD));
  }
  return entry;
}

codeql::BinaryExpr ExprVisitor::translateBinaryExpr(const swift::BinaryExpr& expr) {
  auto entry = createExprEntry(expr);
  fillApplyExpr(expr, entry);
  return entry;
}

codeql::TupleExpr ExprVisitor::translateTupleExpr(const swift::TupleExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.elements = dispatcher_.fetchRepeatedLabels(expr.getElements());
  return entry;
}

codeql::DefaultArgumentExpr ExprVisitor::translateDefaultArgumentExpr(
    const swift::DefaultArgumentExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.param_decl = dispatcher_.fetchLabel(expr.getParamDecl());
  entry.param_index = expr.getParamIndex();
  if (expr.isCallerSide()) {
    entry.caller_side_default = dispatcher_.fetchLabel(expr.getCallerSideDefaultExpr());
  }
  return entry;
}

codeql::DotSyntaxBaseIgnoredExpr ExprVisitor::translateDotSyntaxBaseIgnoredExpr(
    const swift::DotSyntaxBaseIgnoredExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.qualifier = dispatcher_.fetchLabel(expr.getLHS());
  entry.sub_expr = dispatcher_.fetchLabel(expr.getRHS());
  return entry;
}

codeql::DynamicTypeExpr ExprVisitor::translateDynamicTypeExpr(const swift::DynamicTypeExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.base = dispatcher_.fetchLabel(expr.getBase());
  return entry;
}

codeql::EnumIsCaseExpr ExprVisitor::translateEnumIsCaseExpr(const swift::EnumIsCaseExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  entry.element = dispatcher_.fetchLabel(expr.getEnumElement());
  return entry;
}

codeql::MakeTemporarilyEscapableExpr ExprVisitor::translateMakeTemporarilyEscapableExpr(
    const swift::MakeTemporarilyEscapableExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.escaping_closure = dispatcher_.fetchLabel(expr.getOpaqueValue());
  entry.nonescaping_closure = dispatcher_.fetchLabel(expr.getNonescapingClosureValue());
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::ObjCSelectorExpr ExprVisitor::translateObjCSelectorExpr(
    const swift::ObjCSelectorExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  entry.method = dispatcher_.fetchLabel(expr.getMethod());
  return entry;
}

codeql::OneWayExpr ExprVisitor::translateOneWayExpr(const swift::OneWayExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::OpenExistentialExpr ExprVisitor::translateOpenExistentialExpr(
    const swift::OpenExistentialExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  entry.existential = dispatcher_.fetchLabel(expr.getExistentialValue());
  entry.opaque_expr = dispatcher_.fetchLabel(expr.getOpaqueValue());
  return entry;
}

codeql::OptionalEvaluationExpr ExprVisitor::translateOptionalEvaluationExpr(
    const swift::OptionalEvaluationExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::RebindSelfInConstructorExpr ExprVisitor::translateRebindSelfInConstructorExpr(
    const swift::RebindSelfInConstructorExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  entry.self = dispatcher_.fetchLabel(expr.getSelf());
  return entry;
}

codeql::SuperRefExpr ExprVisitor::translateSuperRefExpr(const swift::SuperRefExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.self = dispatcher_.fetchLabel(expr.getSelf());
  return entry;
}

codeql::DotSyntaxCallExpr ExprVisitor::translateDotSyntaxCallExpr(
    const swift::DotSyntaxCallExpr& expr) {
  auto entry = createExprEntry(expr);
  fillSelfApplyExpr(expr, entry);
  return entry;
}

codeql::VarargExpansionExpr ExprVisitor::translateVarargExpansionExpr(
    const swift::VarargExpansionExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::ArrayExpr ExprVisitor::translateArrayExpr(const swift::ArrayExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.elements = dispatcher_.fetchRepeatedLabels(expr.getElements());
  return entry;
}

codeql::TypeExpr ExprVisitor::translateTypeExpr(const swift::TypeExpr& expr) {
  auto entry = createExprEntry(expr);
  if (expr.getTypeRepr() && expr.getInstanceType()) {
    entry.type_repr = dispatcher_.fetchLabel(expr.getTypeRepr(), expr.getInstanceType());
  }
  return entry;
}

codeql::ParenExpr ExprVisitor::translateParenExpr(const swift::ParenExpr& expr) {
  auto entry = createExprEntry(expr);
  fillIdentityExpr(expr, entry);
  return entry;
}

codeql::InOutExpr ExprVisitor::translateInOutExpr(const swift::InOutExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::OpaqueValueExpr ExprVisitor::translateOpaqueValueExpr(const swift::OpaqueValueExpr& expr) {
  auto entry = createExprEntry(expr);
  return entry;
}

codeql::TapExpr ExprVisitor::translateTapExpr(const swift::TapExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.var = dispatcher_.fetchLabel(expr.getVar());
  entry.body = dispatcher_.fetchLabel(expr.getBody());
  entry.sub_expr = dispatcher_.fetchOptionalLabel(expr.getSubExpr());
  return entry;
}

codeql::TupleElementExpr ExprVisitor::translateTupleElementExpr(
    const swift::TupleElementExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getBase());
  entry.index = expr.getFieldNumber();
  return entry;
}

codeql::TryExpr ExprVisitor::translateTryExpr(const swift::TryExpr& expr) {
  auto entry = createExprEntry(expr);
  fillAnyTryExpr(expr, entry);
  return entry;
}

codeql::ForceTryExpr ExprVisitor::translateForceTryExpr(const swift::ForceTryExpr& expr) {
  auto entry = createExprEntry(expr);
  fillAnyTryExpr(expr, entry);
  return entry;
}

codeql::OptionalTryExpr ExprVisitor::translateOptionalTryExpr(const swift::OptionalTryExpr& expr) {
  auto entry = createExprEntry(expr);
  fillAnyTryExpr(expr, entry);
  return entry;
}

codeql::ConstructorRefCallExpr ExprVisitor::translateConstructorRefCallExpr(
    const swift::ConstructorRefCallExpr& expr) {
  auto entry = createExprEntry(expr);
  fillSelfApplyExpr(expr, entry);
  return entry;
}

codeql::DiscardAssignmentExpr ExprVisitor::translateDiscardAssignmentExpr(
    const swift::DiscardAssignmentExpr& expr) {
  auto entry = createExprEntry(expr);
  return entry;
}

codeql::ClosureExpr ExprVisitor::translateClosureExpr(const swift::ClosureExpr& expr) {
  auto entry = createExprEntry(expr);
  fillAbstractClosureExpr(expr, entry);
  return entry;
}

codeql::AutoClosureExpr ExprVisitor::translateAutoClosureExpr(const swift::AutoClosureExpr& expr) {
  auto entry = createExprEntry(expr);
  fillAbstractClosureExpr(expr, entry);
  return entry;
}

codeql::CoerceExpr ExprVisitor::translateCoerceExpr(const swift::CoerceExpr& expr) {
  auto entry = createExprEntry(expr);
  fillExplicitCastExpr(expr, entry);
  return entry;
}

codeql::ConditionalCheckedCastExpr ExprVisitor::translateConditionalCheckedCastExpr(
    const swift::ConditionalCheckedCastExpr& expr) {
  auto entry = createExprEntry(expr);
  fillExplicitCastExpr(expr, entry);
  return entry;
}

codeql::ForcedCheckedCastExpr ExprVisitor::translateForcedCheckedCastExpr(
    const swift::ForcedCheckedCastExpr& expr) {
  auto entry = createExprEntry(expr);
  fillExplicitCastExpr(expr, entry);
  return entry;
}

codeql::IsExpr ExprVisitor::translateIsExpr(const swift::IsExpr& expr) {
  auto entry = createExprEntry(expr);
  fillExplicitCastExpr(expr, entry);
  return entry;
}

codeql::SubscriptExpr ExprVisitor::translateSubscriptExpr(const swift::SubscriptExpr& expr) {
  auto entry = createExprEntry(expr);
  fillAccessorSemantics(expr, entry);
  assert(expr.getArgs() && "SubscriptExpr has getArgs");
  for (const auto& arg : *expr.getArgs()) {
    entry.arguments.push_back(emitArgument(arg));
  }
  fillLookupExpr(expr, entry);
  return entry;
}

codeql::DictionaryExpr ExprVisitor::translateDictionaryExpr(const swift::DictionaryExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.elements = dispatcher_.fetchRepeatedLabels(expr.getElements());
  return entry;
}

codeql::MemberRefExpr ExprVisitor::translateMemberRefExpr(const swift::MemberRefExpr& expr) {
  auto entry = createExprEntry(expr);
  fillAccessorSemantics(expr, entry);
  fillLookupExpr(expr, entry);
  return entry;
}

codeql::KeyPathExpr ExprVisitor::translateKeyPathExpr(const swift::KeyPathExpr& expr) {
  auto entry = createExprEntry(expr);
  // TODO this should be completely redone, as we are using internal stuff here instead of
  // extracting expr.getComponents()
  if (!expr.isObjC()) {
    entry.parsed_path = dispatcher_.fetchOptionalLabel(expr.getParsedPath());
    if (auto rootTypeRepr = expr.getRootType()) {
      auto keyPathType = expr.getType()->getAs<swift::BoundGenericClassType>();
      assert(keyPathType && "KeyPathExpr must have BoundGenericClassType");
      auto keyPathTypeArgs = keyPathType->getGenericArgs();
      assert(keyPathTypeArgs.size() != 0 && "KeyPathExpr type must have generic args");
      entry.root = dispatcher_.fetchLabel(rootTypeRepr, keyPathTypeArgs[0]);
    }
  }
  return entry;
}

codeql::LazyInitializerExpr ExprVisitor::translateLazyInitializerExpr(
    const swift::LazyInitializerExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::ForceValueExpr ExprVisitor::translateForceValueExpr(const swift::ForceValueExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::IfExpr ExprVisitor::translateIfExpr(const swift::IfExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.condition = dispatcher_.fetchLabel(expr.getCondExpr());
  entry.then_expr = dispatcher_.fetchLabel(expr.getThenExpr());
  entry.else_expr = dispatcher_.fetchLabel(expr.getElseExpr());
  return entry;
}

codeql::KeyPathDotExpr ExprVisitor::translateKeyPathDotExpr(const swift::KeyPathDotExpr& expr) {
  auto entry = createExprEntry(expr);
  return entry;
}

codeql::KeyPathApplicationExpr ExprVisitor::translateKeyPathApplicationExpr(
    const swift::KeyPathApplicationExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.base = dispatcher_.fetchLabel(expr.getBase());
  entry.key_path = dispatcher_.fetchLabel(expr.getKeyPath());
  return entry;
}

codeql::OtherConstructorDeclRefExpr ExprVisitor::translateOtherConstructorDeclRefExpr(
    const swift::OtherConstructorDeclRefExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.constructor_decl = dispatcher_.fetchLabel(expr.getDecl());
  return entry;
}

codeql::UnresolvedDeclRefExpr ExprVisitor::translateUnresolvedDeclRefExpr(
    const swift::UnresolvedDeclRefExpr& expr) {
  auto entry = createExprEntry(expr);
  if (expr.hasName()) {
    llvm::SmallVector<char> scratch;
    entry.name = expr.getName().getString(scratch).str();
  }
  return entry;
}

codeql::UnresolvedDotExpr ExprVisitor::translateUnresolvedDotExpr(
    const swift::UnresolvedDotExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.base = dispatcher_.fetchLabel(expr.getBase());
  llvm::SmallVector<char> scratch;
  entry.name = expr.getName().getString(scratch).str();
  return entry;
}

codeql::UnresolvedMemberExpr ExprVisitor::translateUnresolvedMemberExpr(
    const swift::UnresolvedMemberExpr& expr) {
  auto entry = createExprEntry(expr);
  llvm::SmallVector<char> scratch;
  entry.name = expr.getName().getString(scratch).str();
  return entry;
}

codeql::SequenceExpr ExprVisitor::translateSequenceExpr(const swift::SequenceExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.elements = dispatcher_.fetchRepeatedLabels(expr.getElements());
  return entry;
}

codeql::DotSelfExpr ExprVisitor::translateDotSelfExpr(const swift::DotSelfExpr& expr) {
  auto entry = createExprEntry(expr);
  fillIdentityExpr(expr, entry);
  return entry;
}

codeql::ErrorExpr ExprVisitor::translateErrorExpr(const swift::ErrorExpr& expr) {
  auto entry = createExprEntry(expr);
  return entry;
}

void ExprVisitor::fillAbstractClosureExpr(const swift::AbstractClosureExpr& expr,
                                          codeql::AbstractClosureExpr& entry) {
  assert(expr.getParameters() && "AbstractClosureExpr has getParameters()");
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

void ExprVisitor::fillExplicitCastExpr(const swift::ExplicitCastExpr& expr,
                                       codeql::ExplicitCastExpr& entry) {
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
}

void ExprVisitor::fillIdentityExpr(const swift::IdentityExpr& expr, codeql::IdentityExpr& entry) {
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
}

void ExprVisitor::fillAnyTryExpr(const swift::AnyTryExpr& expr, codeql::AnyTryExpr& entry) {
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
}

void ExprVisitor::fillApplyExpr(const swift::ApplyExpr& expr, codeql::ApplyExpr& entry) {
  entry.function = dispatcher_.fetchLabel(expr.getFn());
  assert(expr.getArgs() && "ApplyExpr has getArgs");
  for (const auto& arg : *expr.getArgs()) {
    entry.arguments.push_back(emitArgument(arg));
  }
}

void ExprVisitor::fillSelfApplyExpr(const swift::SelfApplyExpr& expr,
                                    codeql::SelfApplyExpr& entry) {
  entry.base = dispatcher_.fetchLabel(expr.getBase());
  fillApplyExpr(expr, entry);
}

void ExprVisitor::fillLookupExpr(const swift::LookupExpr& expr, codeql::LookupExpr& entry) {
  entry.base = dispatcher_.fetchLabel(expr.getBase());
  if (expr.hasDecl()) {
    entry.member = dispatcher_.fetchLabel(expr.getDecl().getDecl());
  }
}

codeql::UnresolvedPatternExpr ExprVisitor::translateUnresolvedPatternExpr(
    const swift::UnresolvedPatternExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_pattern = dispatcher_.fetchLabel(expr.getSubPattern());
  return entry;
}
}  // namespace codeql
