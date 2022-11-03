#include "swift/extractor/translators/ExprTranslator.h"

#include <swift/AST/ParameterList.h>

namespace codeql {

template <typename T>
void ExprTranslator::fillAccessorSemantics(const T& ast, TrapClassOf<T>& entry) {
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

codeql::IntegerLiteralExpr ExprTranslator::translateIntegerLiteralExpr(
    const swift::IntegerLiteralExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.string_value = (expr.isNegative() ? "-" : "") + expr.getDigitsText().str();
  return entry;
}

codeql::FloatLiteralExpr ExprTranslator::translateFloatLiteralExpr(
    const swift::FloatLiteralExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.string_value = (expr.isNegative() ? "-" : "") + expr.getDigitsText().str();
  return entry;
}

codeql::BooleanLiteralExpr ExprTranslator::translateBooleanLiteralExpr(
    const swift::BooleanLiteralExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.value = expr.getValue();
  return entry;
}

codeql::MagicIdentifierLiteralExpr ExprTranslator::translateMagicIdentifierLiteralExpr(
    const swift::MagicIdentifierLiteralExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.kind = swift::MagicIdentifierLiteralExpr::getKindString(expr.getKind()).str();
  return entry;
}

codeql::StringLiteralExpr ExprTranslator::translateStringLiteralExpr(
    const swift::StringLiteralExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.value = expr.getValue().str();
  return entry;
}

codeql::InterpolatedStringLiteralExpr ExprTranslator::translateInterpolatedStringLiteralExpr(
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

codeql::NilLiteralExpr ExprTranslator::translateNilLiteralExpr(const swift::NilLiteralExpr& expr) {
  auto entry = createExprEntry(expr);
  return entry;
}

codeql::CallExpr ExprTranslator::translateCallExpr(const swift::CallExpr& expr) {
  auto entry = createExprEntry(expr);
  fillApplyExpr(expr, entry);
  return entry;
}

codeql::PrefixUnaryExpr ExprTranslator::translatePrefixUnaryExpr(
    const swift::PrefixUnaryExpr& expr) {
  auto entry = createExprEntry(expr);
  fillApplyExpr(expr, entry);
  return entry;
}

codeql::DeclRefExpr ExprTranslator::translateDeclRefExpr(const swift::DeclRefExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.decl = dispatcher_.fetchLabel(expr.getDecl());
  fillAccessorSemantics(expr, entry);
  entry.replacement_types =
      dispatcher_.fetchRepeatedLabels(expr.getDeclRef().getSubstitutions().getReplacementTypes());
  return entry;
}

codeql::AssignExpr ExprTranslator::translateAssignExpr(const swift::AssignExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.dest = dispatcher_.fetchLabel(expr.getDest());
  entry.source = dispatcher_.fetchLabel(expr.getSrc());
  return entry;
}

codeql::BindOptionalExpr ExprTranslator::translateBindOptionalExpr(
    const swift::BindOptionalExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::CaptureListExpr ExprTranslator::translateCaptureListExpr(
    const swift::CaptureListExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.closure_body = dispatcher_.fetchLabel(expr.getClosureBody());
  for (const auto& item : const_cast<swift::CaptureListExpr&>(expr).getCaptureList()) {
    entry.binding_decls.push_back(dispatcher_.fetchLabel(item.PBD));
  }
  return entry;
}

codeql::BinaryExpr ExprTranslator::translateBinaryExpr(const swift::BinaryExpr& expr) {
  auto entry = createExprEntry(expr);
  fillApplyExpr(expr, entry);
  return entry;
}

codeql::TupleExpr ExprTranslator::translateTupleExpr(const swift::TupleExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.elements = dispatcher_.fetchRepeatedLabels(expr.getElements());
  return entry;
}

codeql::DefaultArgumentExpr ExprTranslator::translateDefaultArgumentExpr(
    const swift::DefaultArgumentExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.param_decl = dispatcher_.fetchLabel(expr.getParamDecl());
  entry.param_index = expr.getParamIndex();
  if (expr.isCallerSide()) {
    entry.caller_side_default = dispatcher_.fetchLabel(expr.getCallerSideDefaultExpr());
  }
  return entry;
}

codeql::DotSyntaxBaseIgnoredExpr ExprTranslator::translateDotSyntaxBaseIgnoredExpr(
    const swift::DotSyntaxBaseIgnoredExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.qualifier = dispatcher_.fetchLabel(expr.getLHS());
  entry.sub_expr = dispatcher_.fetchLabel(expr.getRHS());
  return entry;
}

codeql::DynamicTypeExpr ExprTranslator::translateDynamicTypeExpr(
    const swift::DynamicTypeExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.base = dispatcher_.fetchLabel(expr.getBase());
  return entry;
}

codeql::EnumIsCaseExpr ExprTranslator::translateEnumIsCaseExpr(const swift::EnumIsCaseExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  entry.element = dispatcher_.fetchLabel(expr.getEnumElement());
  return entry;
}

codeql::MakeTemporarilyEscapableExpr ExprTranslator::translateMakeTemporarilyEscapableExpr(
    const swift::MakeTemporarilyEscapableExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.escaping_closure = dispatcher_.fetchLabel(expr.getOpaqueValue());
  entry.nonescaping_closure = dispatcher_.fetchLabel(expr.getNonescapingClosureValue());
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::ObjCSelectorExpr ExprTranslator::translateObjCSelectorExpr(
    const swift::ObjCSelectorExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  entry.method = dispatcher_.fetchLabel(expr.getMethod());
  return entry;
}

codeql::OneWayExpr ExprTranslator::translateOneWayExpr(const swift::OneWayExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::OpenExistentialExpr ExprTranslator::translateOpenExistentialExpr(
    const swift::OpenExistentialExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  entry.existential = dispatcher_.fetchLabel(expr.getExistentialValue());
  entry.opaque_expr = dispatcher_.fetchLabel(expr.getOpaqueValue());
  return entry;
}

codeql::OptionalEvaluationExpr ExprTranslator::translateOptionalEvaluationExpr(
    const swift::OptionalEvaluationExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::RebindSelfInConstructorExpr ExprTranslator::translateRebindSelfInConstructorExpr(
    const swift::RebindSelfInConstructorExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  entry.self = dispatcher_.fetchLabel(expr.getSelf());
  return entry;
}

codeql::SuperRefExpr ExprTranslator::translateSuperRefExpr(const swift::SuperRefExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.self = dispatcher_.fetchLabel(expr.getSelf());
  return entry;
}

codeql::DotSyntaxCallExpr ExprTranslator::translateDotSyntaxCallExpr(
    const swift::DotSyntaxCallExpr& expr) {
  auto entry = createExprEntry(expr);
  fillSelfApplyExpr(expr, entry);
  return entry;
}

codeql::VarargExpansionExpr ExprTranslator::translateVarargExpansionExpr(
    const swift::VarargExpansionExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::ArrayExpr ExprTranslator::translateArrayExpr(const swift::ArrayExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.elements = dispatcher_.fetchRepeatedLabels(expr.getElements());
  return entry;
}

codeql::TypeExpr ExprTranslator::translateTypeExpr(const swift::TypeExpr& expr) {
  auto entry = createExprEntry(expr);
  if (expr.getTypeRepr() && expr.getInstanceType()) {
    entry.type_repr = dispatcher_.fetchLabel(expr.getTypeRepr(), expr.getInstanceType());
  }
  return entry;
}

codeql::ParenExpr ExprTranslator::translateParenExpr(const swift::ParenExpr& expr) {
  auto entry = createExprEntry(expr);
  fillIdentityExpr(expr, entry);
  return entry;
}

codeql::InOutExpr ExprTranslator::translateInOutExpr(const swift::InOutExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::OpaqueValueExpr ExprTranslator::translateOpaqueValueExpr(
    const swift::OpaqueValueExpr& expr) {
  auto entry = createExprEntry(expr);
  return entry;
}

codeql::TapExpr ExprTranslator::translateTapExpr(const swift::TapExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.var = dispatcher_.fetchLabel(expr.getVar());
  entry.body = dispatcher_.fetchLabel(expr.getBody());
  entry.sub_expr = dispatcher_.fetchOptionalLabel(expr.getSubExpr());
  return entry;
}

codeql::TupleElementExpr ExprTranslator::translateTupleElementExpr(
    const swift::TupleElementExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getBase());
  entry.index = expr.getFieldNumber();
  return entry;
}

codeql::TryExpr ExprTranslator::translateTryExpr(const swift::TryExpr& expr) {
  auto entry = createExprEntry(expr);
  fillAnyTryExpr(expr, entry);
  return entry;
}

codeql::ForceTryExpr ExprTranslator::translateForceTryExpr(const swift::ForceTryExpr& expr) {
  auto entry = createExprEntry(expr);
  fillAnyTryExpr(expr, entry);
  return entry;
}

codeql::OptionalTryExpr ExprTranslator::translateOptionalTryExpr(
    const swift::OptionalTryExpr& expr) {
  auto entry = createExprEntry(expr);
  fillAnyTryExpr(expr, entry);
  return entry;
}

codeql::ConstructorRefCallExpr ExprTranslator::translateConstructorRefCallExpr(
    const swift::ConstructorRefCallExpr& expr) {
  auto entry = createExprEntry(expr);
  fillSelfApplyExpr(expr, entry);
  return entry;
}

codeql::DiscardAssignmentExpr ExprTranslator::translateDiscardAssignmentExpr(
    const swift::DiscardAssignmentExpr& expr) {
  auto entry = createExprEntry(expr);
  return entry;
}

codeql::ClosureExpr ExprTranslator::translateClosureExpr(const swift::ClosureExpr& expr) {
  auto entry = createExprEntry(expr);
  fillAbstractClosureExpr(expr, entry);
  return entry;
}

codeql::AutoClosureExpr ExprTranslator::translateAutoClosureExpr(
    const swift::AutoClosureExpr& expr) {
  auto entry = createExprEntry(expr);
  fillAbstractClosureExpr(expr, entry);
  return entry;
}

codeql::CoerceExpr ExprTranslator::translateCoerceExpr(const swift::CoerceExpr& expr) {
  auto entry = createExprEntry(expr);
  fillExplicitCastExpr(expr, entry);
  return entry;
}

codeql::ConditionalCheckedCastExpr ExprTranslator::translateConditionalCheckedCastExpr(
    const swift::ConditionalCheckedCastExpr& expr) {
  auto entry = createExprEntry(expr);
  fillExplicitCastExpr(expr, entry);
  return entry;
}

codeql::ForcedCheckedCastExpr ExprTranslator::translateForcedCheckedCastExpr(
    const swift::ForcedCheckedCastExpr& expr) {
  auto entry = createExprEntry(expr);
  fillExplicitCastExpr(expr, entry);
  return entry;
}

codeql::IsExpr ExprTranslator::translateIsExpr(const swift::IsExpr& expr) {
  auto entry = createExprEntry(expr);
  fillExplicitCastExpr(expr, entry);
  return entry;
}

codeql::SubscriptExpr ExprTranslator::translateSubscriptExpr(const swift::SubscriptExpr& expr) {
  auto entry = createExprEntry(expr);
  fillAccessorSemantics(expr, entry);
  assert(expr.getArgs() && "SubscriptExpr has getArgs");
  for (const auto& arg : *expr.getArgs()) {
    entry.arguments.push_back(emitArgument(arg));
  }
  fillLookupExpr(expr, entry);
  return entry;
}

codeql::DictionaryExpr ExprTranslator::translateDictionaryExpr(const swift::DictionaryExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.elements = dispatcher_.fetchRepeatedLabels(expr.getElements());
  return entry;
}

codeql::MemberRefExpr ExprTranslator::translateMemberRefExpr(const swift::MemberRefExpr& expr) {
  auto entry = createExprEntry(expr);
  fillAccessorSemantics(expr, entry);
  fillLookupExpr(expr, entry);
  return entry;
}

codeql::KeyPathExpr ExprTranslator::translateKeyPathExpr(const swift::KeyPathExpr& expr) {
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

codeql::LazyInitializerExpr ExprTranslator::translateLazyInitializerExpr(
    const swift::LazyInitializerExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::ForceValueExpr ExprTranslator::translateForceValueExpr(const swift::ForceValueExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::IfExpr ExprTranslator::translateIfExpr(const swift::IfExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.condition = dispatcher_.fetchLabel(expr.getCondExpr());
  entry.then_expr = dispatcher_.fetchLabel(expr.getThenExpr());
  entry.else_expr = dispatcher_.fetchLabel(expr.getElseExpr());
  return entry;
}

codeql::KeyPathDotExpr ExprTranslator::translateKeyPathDotExpr(const swift::KeyPathDotExpr& expr) {
  auto entry = createExprEntry(expr);
  return entry;
}

codeql::KeyPathApplicationExpr ExprTranslator::translateKeyPathApplicationExpr(
    const swift::KeyPathApplicationExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.base = dispatcher_.fetchLabel(expr.getBase());
  entry.key_path = dispatcher_.fetchLabel(expr.getKeyPath());
  return entry;
}

codeql::OtherConstructorDeclRefExpr ExprTranslator::translateOtherConstructorDeclRefExpr(
    const swift::OtherConstructorDeclRefExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.constructor_decl = dispatcher_.fetchLabel(expr.getDecl());
  return entry;
}

codeql::UnresolvedDeclRefExpr ExprTranslator::translateUnresolvedDeclRefExpr(
    const swift::UnresolvedDeclRefExpr& expr) {
  auto entry = createExprEntry(expr);
  if (expr.hasName()) {
    llvm::SmallVector<char> scratch;
    entry.name = expr.getName().getString(scratch).str();
  }
  return entry;
}

codeql::UnresolvedDotExpr ExprTranslator::translateUnresolvedDotExpr(
    const swift::UnresolvedDotExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.base = dispatcher_.fetchLabel(expr.getBase());
  llvm::SmallVector<char> scratch;
  entry.name = expr.getName().getString(scratch).str();
  return entry;
}

codeql::UnresolvedMemberExpr ExprTranslator::translateUnresolvedMemberExpr(
    const swift::UnresolvedMemberExpr& expr) {
  auto entry = createExprEntry(expr);
  llvm::SmallVector<char> scratch;
  entry.name = expr.getName().getString(scratch).str();
  return entry;
}

codeql::SequenceExpr ExprTranslator::translateSequenceExpr(const swift::SequenceExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.elements = dispatcher_.fetchRepeatedLabels(expr.getElements());
  return entry;
}

codeql::DotSelfExpr ExprTranslator::translateDotSelfExpr(const swift::DotSelfExpr& expr) {
  auto entry = createExprEntry(expr);
  fillIdentityExpr(expr, entry);
  return entry;
}

codeql::ErrorExpr ExprTranslator::translateErrorExpr(const swift::ErrorExpr& expr) {
  auto entry = createExprEntry(expr);
  return entry;
}

void ExprTranslator::fillAbstractClosureExpr(const swift::AbstractClosureExpr& expr,
                                             codeql::AbstractClosureExpr& entry) {
  assert(expr.getParameters() && "AbstractClosureExpr has getParameters()");
  entry.params = dispatcher_.fetchRepeatedLabels(*expr.getParameters());
  entry.body = dispatcher_.fetchLabel(expr.getBody());
}

TrapLabel<ArgumentTag> ExprTranslator::emitArgument(const swift::Argument& arg) {
  auto entry = dispatcher_.createUncachedEntry(arg);
  entry.label = arg.getLabel().str().str();
  entry.expr = dispatcher_.fetchLabel(arg.getExpr());
  dispatcher_.emit(entry);
  return entry.id;
}

void ExprTranslator::fillExplicitCastExpr(const swift::ExplicitCastExpr& expr,
                                          codeql::ExplicitCastExpr& entry) {
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
}

void ExprTranslator::fillIdentityExpr(const swift::IdentityExpr& expr,
                                      codeql::IdentityExpr& entry) {
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
}

void ExprTranslator::fillAnyTryExpr(const swift::AnyTryExpr& expr, codeql::AnyTryExpr& entry) {
  entry.sub_expr = dispatcher_.fetchLabel(expr.getSubExpr());
}

void ExprTranslator::fillApplyExpr(const swift::ApplyExpr& expr, codeql::ApplyExpr& entry) {
  entry.function = dispatcher_.fetchLabel(expr.getFn());
  assert(expr.getArgs() && "ApplyExpr has getArgs");
  for (const auto& arg : *expr.getArgs()) {
    entry.arguments.push_back(emitArgument(arg));
  }
}

void ExprTranslator::fillSelfApplyExpr(const swift::SelfApplyExpr& expr,
                                       codeql::SelfApplyExpr& entry) {
  entry.base = dispatcher_.fetchLabel(expr.getBase());
  fillApplyExpr(expr, entry);
}

void ExprTranslator::fillLookupExpr(const swift::LookupExpr& expr, codeql::LookupExpr& entry) {
  entry.base = dispatcher_.fetchLabel(expr.getBase());
  if (expr.hasDecl()) {
    entry.member = dispatcher_.fetchLabel(expr.getDecl().getDecl());
  }
}

codeql::UnresolvedPatternExpr ExprTranslator::translateUnresolvedPatternExpr(
    const swift::UnresolvedPatternExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_pattern = dispatcher_.fetchLabel(expr.getSubPattern());
  return entry;
}
}  // namespace codeql
