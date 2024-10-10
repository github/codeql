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
    case swift::AccessSemantics::DistributedThunk:
      entry.has_distributed_thunk_semantics = true;
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
  entry.interpolation_expr = dispatcher.fetchOptionalLabel(expr.getInterpolationExpr());
  entry.appending_expr = dispatcher.fetchOptionalLabel(expr.getAppendingExpr());
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

codeql::PostfixUnaryExpr ExprTranslator::translatePostfixUnaryExpr(
    const swift::PostfixUnaryExpr& expr) {
  auto entry = createExprEntry(expr);
  fillApplyExpr(expr, entry);
  return entry;
}

codeql::DeclRefExpr ExprTranslator::translateDeclRefExpr(const swift::DeclRefExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.decl = dispatcher.fetchLabel(expr.getDecl());
  fillAccessorSemantics(expr, entry);
  entry.replacement_types =
      dispatcher.fetchRepeatedLabels(expr.getDeclRef().getSubstitutions().getReplacementTypes());
  return entry;
}

codeql::AssignExpr ExprTranslator::translateAssignExpr(const swift::AssignExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.dest = dispatcher.fetchLabel(expr.getDest());
  entry.source = dispatcher.fetchLabel(expr.getSrc());
  return entry;
}

codeql::BindOptionalExpr ExprTranslator::translateBindOptionalExpr(
    const swift::BindOptionalExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::CaptureListExpr ExprTranslator::translateCaptureListExpr(
    const swift::CaptureListExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.closure_body = dispatcher.fetchLabel(expr.getClosureBody());
  for (const auto& item : const_cast<swift::CaptureListExpr&>(expr).getCaptureList()) {
    entry.binding_decls.push_back(dispatcher.fetchLabel(item.PBD));
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
  entry.elements = dispatcher.fetchRepeatedLabels(expr.getElements());
  return entry;
}

codeql::DefaultArgumentExpr ExprTranslator::translateDefaultArgumentExpr(
    const swift::DefaultArgumentExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.param_decl = dispatcher.fetchLabel(expr.getParamDecl());
  entry.param_index = expr.getParamIndex();
  if (expr.isCallerSide()) {
    entry.caller_side_default = dispatcher.fetchLabel(expr.getCallerSideDefaultExpr());
  }
  return entry;
}

codeql::DotSyntaxBaseIgnoredExpr ExprTranslator::translateDotSyntaxBaseIgnoredExpr(
    const swift::DotSyntaxBaseIgnoredExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.qualifier = dispatcher.fetchLabel(expr.getLHS());
  entry.sub_expr = dispatcher.fetchLabel(expr.getRHS());
  return entry;
}

codeql::DynamicTypeExpr ExprTranslator::translateDynamicTypeExpr(
    const swift::DynamicTypeExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.base = dispatcher.fetchLabel(expr.getBase());
  return entry;
}

codeql::EnumIsCaseExpr ExprTranslator::translateEnumIsCaseExpr(const swift::EnumIsCaseExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher.fetchLabel(expr.getSubExpr());
  entry.element = dispatcher.fetchLabel(expr.getEnumElement());
  return entry;
}

codeql::MakeTemporarilyEscapableExpr ExprTranslator::translateMakeTemporarilyEscapableExpr(
    const swift::MakeTemporarilyEscapableExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.escaping_closure = dispatcher.fetchLabel(expr.getOpaqueValue());
  entry.nonescaping_closure = dispatcher.fetchLabel(expr.getNonescapingClosureValue());
  entry.sub_expr = dispatcher.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::ObjCSelectorExpr ExprTranslator::translateObjCSelectorExpr(
    const swift::ObjCSelectorExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher.fetchLabel(expr.getSubExpr());
  entry.method = dispatcher.fetchLabel(expr.getMethod());
  return entry;
}

codeql::OneWayExpr ExprTranslator::translateOneWayExpr(const swift::OneWayExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::OpenExistentialExpr ExprTranslator::translateOpenExistentialExpr(
    const swift::OpenExistentialExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher.fetchLabel(expr.getSubExpr());
  entry.existential = dispatcher.fetchLabel(expr.getExistentialValue());
  entry.opaque_expr = dispatcher.fetchLabel(expr.getOpaqueValue());
  return entry;
}

codeql::OptionalEvaluationExpr ExprTranslator::translateOptionalEvaluationExpr(
    const swift::OptionalEvaluationExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::RebindSelfInInitializerExpr ExprTranslator::translateRebindSelfInConstructorExpr(
    const swift::RebindSelfInConstructorExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher.fetchLabel(expr.getSubExpr());
  entry.self = dispatcher.fetchLabel(expr.getSelf());
  return entry;
}

codeql::SuperRefExpr ExprTranslator::translateSuperRefExpr(const swift::SuperRefExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.self = dispatcher.fetchLabel(expr.getSelf());
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
  entry.sub_expr = dispatcher.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::ArrayExpr ExprTranslator::translateArrayExpr(const swift::ArrayExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.elements = dispatcher.fetchRepeatedLabels(expr.getElements());
  return entry;
}

codeql::TypeExpr ExprTranslator::translateTypeExpr(const swift::TypeExpr& expr) {
  auto entry = createExprEntry(expr);
  if (expr.getTypeRepr() && expr.getInstanceType()) {
    entry.type_repr = dispatcher.fetchLabel(expr.getTypeRepr(), expr.getInstanceType());
  }
  return entry;
}

codeql::InOutExpr ExprTranslator::translateInOutExpr(const swift::InOutExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::OpaqueValueExpr ExprTranslator::translateOpaqueValueExpr(
    const swift::OpaqueValueExpr& expr) {
  auto entry = createExprEntry(expr);
  return entry;
}

codeql::TapExpr ExprTranslator::translateTapExpr(const swift::TapExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.var = dispatcher.fetchLabel(expr.getVar());
  entry.body = dispatcher.fetchLabel(expr.getBody());
  entry.sub_expr = dispatcher.fetchOptionalLabel(expr.getSubExpr());
  return entry;
}

codeql::TupleElementExpr ExprTranslator::translateTupleElementExpr(
    const swift::TupleElementExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher.fetchLabel(expr.getBase());
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

codeql::InitializerRefCallExpr ExprTranslator::translateConstructorRefCallExpr(
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

codeql::ExplicitClosureExpr ExprTranslator::translateClosureExpr(const swift::ClosureExpr& expr) {
  auto entry = createExprEntry(expr);
  fillClosureExpr(expr, entry);
  return entry;
}

codeql::AutoClosureExpr ExprTranslator::translateAutoClosureExpr(
    const swift::AutoClosureExpr& expr) {
  auto entry = createExprEntry(expr);
  fillClosureExpr(expr, entry);
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
  fillLookupExpr(expr, entry);
  CODEQL_EXPECT_OR(return entry, expr.getArgs(), "SubscriptExpr has null getArgs");
  for (const auto& arg : *expr.getArgs()) {
    entry.arguments.push_back(emitArgument(arg));
  }
  return entry;
}

codeql::DictionaryExpr ExprTranslator::translateDictionaryExpr(const swift::DictionaryExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.elements = dispatcher.fetchRepeatedLabels(expr.getElements());
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
  if (!expr.isObjC()) {
    for (const auto& component : expr.getComponents()) {
      entry.components.push_back(emitKeyPathComponent(component));
    }
    if (auto rootTypeRepr = expr.getExplicitRootType()) {
      auto keyPathType = expr.getType()->getAs<swift::BoundGenericClassType>();
      CODEQL_EXPECT_OR(return entry, keyPathType, "KeyPathExpr must have BoundGenericClassType");
      auto keyPathTypeArgs = keyPathType->getGenericArgs();
      CODEQL_EXPECT_OR(return entry, keyPathTypeArgs.size() != 0,
                              "KeyPathExpr type must have generic args");
      entry.root = dispatcher.fetchLabel(rootTypeRepr, keyPathTypeArgs[0]);
    }
  }
  return entry;
}

codeql::LazyInitializationExpr ExprTranslator::translateLazyInitializerExpr(
    const swift::LazyInitializerExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::ForceValueExpr ExprTranslator::translateForceValueExpr(const swift::ForceValueExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::IfExpr ExprTranslator::translateTernaryExpr(const swift::TernaryExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.condition = dispatcher.fetchLabel(expr.getCondExpr());
  entry.then_expr = dispatcher.fetchLabel(expr.getThenExpr());
  entry.else_expr = dispatcher.fetchLabel(expr.getElseExpr());
  return entry;
}

codeql::KeyPathDotExpr ExprTranslator::translateKeyPathDotExpr(const swift::KeyPathDotExpr& expr) {
  auto entry = createExprEntry(expr);
  return entry;
}

codeql::KeyPathApplicationExpr ExprTranslator::translateKeyPathApplicationExpr(
    const swift::KeyPathApplicationExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.base = dispatcher.fetchLabel(expr.getBase());
  entry.key_path = dispatcher.fetchLabel(expr.getKeyPath());
  return entry;
}

codeql::OtherInitializerRefExpr ExprTranslator::translateOtherConstructorDeclRefExpr(
    const swift::OtherConstructorDeclRefExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.initializer = dispatcher.fetchLabel(expr.getDecl());
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
  entry.base = dispatcher.fetchLabel(expr.getBase());
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
  // SequenceExpr represents a flat tree of expressions with elements at odd indices being the
  // parents of the elements with even indices, so we only extract the "parent" elements here. In
  // case there is a single child, we extract it as a parent. See
  // https://github.com/github/codeql/pull/14119 and commit message for more details.
  if (expr.getNumElements() == 1) {
    entry.elements = dispatcher.fetchRepeatedLabels(expr.getElements());
  } else {
    for (int i = 1; i < expr.getNumElements(); i += 2) {
      entry.elements.emplace_back(dispatcher.fetchLabel(expr.getElement(i)));
    }
  }
  return entry;
}

codeql::ErrorExpr ExprTranslator::translateErrorExpr(const swift::ErrorExpr& expr) {
  auto entry = createExprEntry(expr);
  return entry;
}

void ExprTranslator::fillClosureExpr(const swift::AbstractClosureExpr& expr,
                                     codeql::ClosureExpr& entry) {
  entry.body = dispatcher.fetchLabel(expr.getBody());
  entry.captures = dispatcher.fetchRepeatedLabels(expr.getCaptureInfo().getCaptures());
  CODEQL_EXPECT_OR(return, expr.getParameters(), "AbstractClosureExpr has null getParameters()");
  entry.params = dispatcher.fetchRepeatedLabels(*expr.getParameters());
}

TrapLabel<ArgumentTag> ExprTranslator::emitArgument(const swift::Argument& arg) {
  auto entry = dispatcher.createUncachedEntry(arg);
  entry.label = arg.getLabel().str().str();
  entry.expr = dispatcher.fetchLabel(arg.getExpr());
  dispatcher.emit(entry);
  return entry.id;
}

TrapLabel<KeyPathComponentTag> ExprTranslator::emitKeyPathComponent(
    const swift::KeyPathExpr::Component& component) {
  auto entry = dispatcher.createUncachedEntry(component);
  entry.kind = static_cast<int>(component.getKind());
  if (auto subscript_args = component.getSubscriptArgs()) {
    for (const auto& arg : *subscript_args) {
      entry.subscript_arguments.push_back(emitArgument(arg));
    }
  }
  if (component.getKind() == swift::KeyPathExpr::Component::Kind::TupleElement) {
    entry.tuple_index = static_cast<int>(component.getTupleIndex());
  }
  if (component.hasDeclRef()) {
    entry.decl_ref = dispatcher.fetchLabel(component.getDeclRef().getDecl());
  }
  entry.component_type = dispatcher.fetchLabel(component.getComponentType());
  dispatcher.emit(entry);
  return entry.id;
}

void ExprTranslator::fillExplicitCastExpr(const swift::ExplicitCastExpr& expr,
                                          codeql::ExplicitCastExpr& entry) {
  entry.sub_expr = dispatcher.fetchLabel(expr.getSubExpr());
}

void ExprTranslator::fillIdentityExpr(const swift::IdentityExpr& expr,
                                      codeql::IdentityExpr& entry) {
  entry.sub_expr = dispatcher.fetchLabel(expr.getSubExpr());
}

void ExprTranslator::fillAnyTryExpr(const swift::AnyTryExpr& expr, codeql::AnyTryExpr& entry) {
  entry.sub_expr = dispatcher.fetchLabel(expr.getSubExpr());
}

void ExprTranslator::fillApplyExpr(const swift::ApplyExpr& expr, codeql::ApplyExpr& entry) {
  entry.function = dispatcher.fetchLabel(expr.getFn());
  CODEQL_EXPECT_OR(return, expr.getArgs(), "ApplyExpr has null getArgs");
  for (const auto& arg : *expr.getArgs()) {
    entry.arguments.push_back(emitArgument(arg));
  }
}

void ExprTranslator::fillSelfApplyExpr(const swift::SelfApplyExpr& expr,
                                       codeql::SelfApplyExpr& entry) {
  entry.base = dispatcher.fetchLabel(expr.getBase());
  fillApplyExpr(expr, entry);
}

void ExprTranslator::fillLookupExpr(const swift::LookupExpr& expr, codeql::LookupExpr& entry) {
  entry.base = dispatcher.fetchLabel(expr.getBase());
  if (expr.hasDecl()) {
    entry.member = dispatcher.fetchLabel(expr.getDecl().getDecl());
  }
}

codeql::UnresolvedPatternExpr ExprTranslator::translateUnresolvedPatternExpr(
    const swift::UnresolvedPatternExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_pattern = dispatcher.fetchLabel(expr.getSubPattern());
  return entry;
}

codeql::ObjectLiteralExpr ExprTranslator::translateObjectLiteralExpr(
    const swift::ObjectLiteralExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.kind = static_cast<int>(expr.getLiteralKind());
  if (auto args = expr.getArgs()) {
    for (const auto& arg : *args) {
      entry.arguments.push_back(emitArgument(arg));
    }
  }
  return entry;
}
codeql::OverloadedDeclRefExpr ExprTranslator::translateOverloadedDeclRefExpr(
    const swift::OverloadedDeclRefExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.possible_declarations = dispatcher.fetchRepeatedLabels(expr.getDecls());
  return entry;
}

codeql::DynamicMemberRefExpr ExprTranslator::translateDynamicMemberRefExpr(
    const swift::DynamicMemberRefExpr& expr) {
  auto entry = createExprEntry(expr);
  fillLookupExpr(expr, entry);
  return entry;
}

codeql::DynamicSubscriptExpr ExprTranslator::translateDynamicSubscriptExpr(
    const swift::DynamicSubscriptExpr& expr) {
  auto entry = createExprEntry(expr);
  fillLookupExpr(expr, entry);
  return entry;
}
codeql::UnresolvedSpecializeExpr ExprTranslator::translateUnresolvedSpecializeExpr(
    const swift::UnresolvedSpecializeExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::PropertyWrapperValuePlaceholderExpr
ExprTranslator::translatePropertyWrapperValuePlaceholderExpr(
    const swift::PropertyWrapperValuePlaceholderExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.wrapped_value = dispatcher.fetchOptionalLabel(expr.getOriginalWrappedValue());
  entry.placeholder = dispatcher.fetchLabel(expr.getOpaqueValuePlaceholder());
  return entry;
}

static int translatePropertyWrapperValueKind(swift::AppliedPropertyWrapperExpr::ValueKind kind) {
  using K = swift::AppliedPropertyWrapperExpr::ValueKind;
  switch (kind) {
    case K::WrappedValue:
      return 1;
    case K::ProjectedValue:
      return 2;
    default:
      return 0;
  }
}

codeql::AppliedPropertyWrapperExpr ExprTranslator::translateAppliedPropertyWrapperExpr(
    const swift::AppliedPropertyWrapperExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.kind = translatePropertyWrapperValueKind(expr.getValueKind());
  entry.value =
      dispatcher.fetchLabel(const_cast<swift::AppliedPropertyWrapperExpr&>(expr).getValue());
  entry.param = dispatcher.fetchLabel(expr.getParamDecl());
  return entry;
}

codeql::RegexLiteralExpr ExprTranslator::translateRegexLiteralExpr(
    const swift::RegexLiteralExpr& expr) {
  auto entry = createExprEntry(expr);
  auto pattern = expr.getRegexText();
  // the pattern has enclosing '/' delimiters, we'd rather get it without
  entry.pattern = pattern.substr(1, pattern.size() - 2);
  entry.version = expr.getVersion();
  return entry;
}

codeql::SingleValueStmtExpr ExprTranslator::translateSingleValueStmtExpr(
    const swift::SingleValueStmtExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.stmt = dispatcher.fetchLabel(expr.getStmt());
  return entry;
}

codeql::PackExpansionExpr ExprTranslator::translatePackExpansionExpr(
    const swift::PackExpansionExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.pattern_expr = dispatcher.fetchLabel(expr.getPatternExpr());
  return entry;
}

codeql::PackElementExpr ExprTranslator::translatePackElementExpr(
    const swift::PackElementExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher.fetchLabel(expr.getPackRefExpr());
  return entry;
}

codeql::CopyExpr ExprTranslator::translateCopyExpr(const swift::CopyExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::ConsumeExpr ExprTranslator::translateConsumeExpr(const swift::ConsumeExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher.fetchLabel(expr.getSubExpr());
  return entry;
}

codeql::MaterializePackExpr ExprTranslator::translateMaterializePackExpr(
    const swift::MaterializePackExpr& expr) {
  auto entry = createExprEntry(expr);
  entry.sub_expr = dispatcher.fetchLabel(expr.getFromExpr());
  return entry;
}

}  // namespace codeql
