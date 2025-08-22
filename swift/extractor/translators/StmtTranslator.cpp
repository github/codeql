#include "swift/extractor/translators/StmtTranslator.h"

namespace codeql {

void StmtTranslator::translateAndEmit(const swift::StmtCondition& cond) {
  auto entry = dispatcher.createEntry(cond);
  entry.elements = dispatcher.fetchRepeatedLabels(cond);
  dispatcher.emit(entry);
}

void StmtTranslator::translateAndEmit(const swift::StmtConditionElement& element) {
  auto entry = dispatcher.createEntry(element);
  if (auto boolean = element.getBooleanOrNull()) {
    entry.boolean = dispatcher.fetchLabel(boolean);
  } else if (auto pattern = element.getPatternOrNull()) {
    entry.pattern = dispatcher.fetchLabel(pattern);
    entry.initializer = dispatcher.fetchLabel(element.getInitializer());
  } else if (auto availability = element.getAvailability()) {
    entry.availability = dispatcher.fetchLabel(availability);
  }
  dispatcher.emit(entry);
}

void StmtTranslator::translateAndEmit(const swift::CaseLabelItem& labelItem) {
  auto entry = dispatcher.createEntry(labelItem);
  entry.pattern = dispatcher.fetchLabel(labelItem.getPattern());
  entry.guard = dispatcher.fetchOptionalLabel(labelItem.getGuardExpr());
  dispatcher.emit(entry);
}

void StmtTranslator::translateAndEmit(const swift::PoundAvailableInfo& availability) {
  auto entry = dispatcher.createEntry(availability);
  entry.is_unavailable = availability.isUnavailability();
  entry.specs = dispatcher.fetchRepeatedLabels(availability.getQueries());
  dispatcher.emit(entry);
}

void StmtTranslator::translateAndEmit(const swift::AvailabilitySpec& spec) {
  if (llvm::isa<swift::PlatformVersionConstraintAvailabilitySpec>(spec)) {
    translateAndEmit(llvm::cast<swift::PlatformVersionConstraintAvailabilitySpec>(spec));
  } else if (llvm::isa<swift::OtherPlatformAvailabilitySpec>(spec)) {
    translateAndEmit(llvm::cast<swift::OtherPlatformAvailabilitySpec>(spec));
  }
}

void StmtTranslator::translateAndEmit(
    const swift::PlatformVersionConstraintAvailabilitySpec& spec) {
  auto entry = dispatcher.createEntry(spec);
  entry.platform = swift::platformString(spec.getPlatform()).str();
  entry.version = spec.getVersion().getAsString();
  dispatcher.emit(entry);
}

void StmtTranslator::translateAndEmit(const swift::OtherPlatformAvailabilitySpec& spec) {
  dispatcher.emit(dispatcher.createEntry(spec));
}

codeql::BraceStmt StmtTranslator::translateBraceStmt(const swift::BraceStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  entry.elements = dispatcher.fetchRepeatedLabels(stmt.getElements());
  return entry;
}

codeql::ReturnStmt StmtTranslator::translateReturnStmt(const swift::ReturnStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  if (stmt.hasResult()) {
    entry.result = dispatcher.fetchLabel(stmt.getResult());
  }
  return entry;
}

codeql::ForEachStmt StmtTranslator::translateForEachStmt(const swift::ForEachStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  fillLabeledStmt(stmt, entry);
  entry.body = dispatcher.fetchLabel(stmt.getBody());
  entry.pattern = dispatcher.fetchLabel(stmt.getPattern());
  entry.iteratorVar = dispatcher.fetchOptionalLabel(stmt.getIteratorVar());
  entry.where = dispatcher.fetchOptionalLabel(stmt.getWhere());
  entry.nextCall = dispatcher.fetchOptionalLabel(stmt.getNextCall());
  auto add_variable = [&](swift::VarDecl* var) {
    entry.variables.push_back(dispatcher.fetchLabel(var));
  };
  if (auto pattern = stmt.getPattern()) {
    pattern->forEachVariable(add_variable);
  }
  if (auto iteratorVar = stmt.getIteratorVar()) {
    for (auto i = 0u; i < iteratorVar->getNumPatternEntries(); ++i) {
      iteratorVar->getPattern(i)->forEachVariable(add_variable);
    }
  }
  return entry;
}

codeql::IfStmt StmtTranslator::translateIfStmt(const swift::IfStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  fillLabeledConditionalStmt(stmt, entry);
  entry.then = dispatcher.fetchLabel(stmt.getThenStmt());
  entry.else_ = dispatcher.fetchOptionalLabel(stmt.getElseStmt());
  return entry;
}

codeql::BreakStmt StmtTranslator::translateBreakStmt(const swift::BreakStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  entry.target = dispatcher.fetchOptionalLabel(stmt.getTarget());
  if (auto targetName = stmt.getTargetName(); !targetName.empty()) {
    entry.target_name = targetName.str().str();
  }
  return entry;
}

codeql::ContinueStmt StmtTranslator::translateContinueStmt(const swift::ContinueStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  entry.target = dispatcher.fetchOptionalLabel(stmt.getTarget());
  if (auto targetName = stmt.getTargetName(); !targetName.empty()) {
    entry.target_name = targetName.str().str();
  }
  return entry;
}

codeql::WhileStmt StmtTranslator::translateWhileStmt(const swift::WhileStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  fillLabeledConditionalStmt(stmt, entry);
  entry.body = dispatcher.fetchLabel(stmt.getBody());
  return entry;
}

codeql::RepeatWhileStmt StmtTranslator::translateRepeatWhileStmt(
    const swift::RepeatWhileStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  fillLabeledStmt(stmt, entry);
  entry.body = dispatcher.fetchLabel(stmt.getBody());
  entry.condition = dispatcher.fetchLabel(stmt.getCond());
  return entry;
}

codeql::DoCatchStmt StmtTranslator::translateDoCatchStmt(const swift::DoCatchStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  fillLabeledStmt(stmt, entry);
  entry.body = dispatcher.fetchLabel(stmt.getBody());
  entry.catches = dispatcher.fetchRepeatedLabels(stmt.getCatches());
  return entry;
}

codeql::CaseStmt StmtTranslator::translateCaseStmt(const swift::CaseStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  entry.body = dispatcher.fetchLabel(stmt.getBody());
  entry.labels = dispatcher.fetchRepeatedLabels(stmt.getCaseLabelItems());
  entry.variables = dispatcher.fetchRepeatedLabels(stmt.getCaseBodyVariablesOrEmptyArray());
  return entry;
}

codeql::GuardStmt StmtTranslator::translateGuardStmt(const swift::GuardStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  fillLabeledConditionalStmt(stmt, entry);
  entry.body = dispatcher.fetchLabel(stmt.getBody());
  return entry;
}

codeql::ThrowStmt StmtTranslator::translateThrowStmt(const swift::ThrowStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  entry.sub_expr = dispatcher.fetchLabel(stmt.getSubExpr());
  return entry;
}

codeql::DeferStmt StmtTranslator::translateDeferStmt(const swift::DeferStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  entry.body = dispatcher.fetchLabel(stmt.getBodyAsWritten());
  return entry;
}

codeql::DoStmt StmtTranslator::translateDoStmt(const swift::DoStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  fillLabeledStmt(stmt, entry);
  entry.body = dispatcher.fetchLabel(stmt.getBody());
  return entry;
}

codeql::SwitchStmt StmtTranslator::translateSwitchStmt(const swift::SwitchStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  fillLabeledStmt(stmt, entry);
  entry.expr = dispatcher.fetchLabel(stmt.getSubjectExpr());
  entry.cases = dispatcher.fetchRepeatedLabels(stmt.getCases());
  return entry;
}

codeql::FallthroughStmt StmtTranslator::translateFallthroughStmt(
    const swift::FallthroughStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  entry.fallthrough_source = dispatcher.fetchLabel(stmt.getFallthroughSource());
  entry.fallthrough_dest = dispatcher.fetchLabel(stmt.getFallthroughDest());
  return entry;
}

codeql::YieldStmt StmtTranslator::translateYieldStmt(const swift::YieldStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  entry.results = dispatcher.fetchRepeatedLabels(stmt.getYields());
  return entry;
}

void StmtTranslator::fillLabeledStmt(const swift::LabeledStmt& stmt, codeql::LabeledStmt& entry) {
  if (auto info = stmt.getLabelInfo()) {
    entry.label = info.Name.str().str();
  }
}

void StmtTranslator::fillLabeledConditionalStmt(const swift::LabeledConditionalStmt& stmt,
                                                codeql::LabeledConditionalStmt& entry) {
  // getCondPointer not provided for const stmt by swift...
  entry.condition =
      dispatcher.fetchLabel(const_cast<swift::LabeledConditionalStmt&>(stmt).getCondPointer());
  fillLabeledStmt(stmt, entry);
}

codeql::FailStmt StmtTranslator::translateFailStmt(const swift::FailStmt& stmt) {
  return dispatcher.createEntry(stmt);
}

codeql::PoundAssertStmt StmtTranslator::translatePoundAssertStmt(
    const swift::PoundAssertStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  entry.condition = dispatcher.fetchLabel(stmt.getCondition());
  entry.message = stmt.getMessage();
  return entry;
}

codeql::DiscardStmt StmtTranslator::translateDiscardStmt(const swift::DiscardStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  entry.sub_expr = dispatcher.fetchLabel(stmt.getSubExpr());
  return entry;
}

codeql::ThenStmt StmtTranslator::translateThenStmt(const swift::ThenStmt& stmt) {
  auto entry = dispatcher.createEntry(stmt);
  entry.result = dispatcher.fetchLabel(stmt.getResult());
  return entry;
}

}  // namespace codeql
