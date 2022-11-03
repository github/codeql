#include "swift/extractor/translators/StmtTranslator.h"

namespace codeql {

codeql::StmtCondition StmtTranslator::translateStmtCondition(const swift::StmtCondition& cond) {
  auto entry = dispatcher_.createEntry(cond);
  entry.elements = dispatcher_.fetchRepeatedLabels(cond);
  return entry;
}

codeql::ConditionElement StmtTranslator::translateStmtConditionElement(
    const swift::StmtConditionElement& element) {
  auto entry = dispatcher_.createEntry(element);
  if (auto boolean = element.getBooleanOrNull()) {
    entry.boolean = dispatcher_.fetchLabel(boolean);
  } else if (auto pattern = element.getPatternOrNull()) {
    entry.pattern = dispatcher_.fetchLabel(pattern);
    entry.initializer = dispatcher_.fetchLabel(element.getInitializer());
  }
  return entry;
}

codeql::CaseLabelItem StmtTranslator::translateCaseLabelItem(
    const swift::CaseLabelItem& labelItem) {
  auto entry = dispatcher_.createEntry(labelItem);
  entry.pattern = dispatcher_.fetchLabel(labelItem.getPattern());
  entry.guard = dispatcher_.fetchOptionalLabel(labelItem.getGuardExpr());
  return entry;
}

codeql::BraceStmt StmtTranslator::translateBraceStmt(const swift::BraceStmt& stmt) {
  auto entry = dispatcher_.createEntry(stmt);
  entry.elements = dispatcher_.fetchRepeatedLabels(stmt.getElements());
  return entry;
}

codeql::ReturnStmt StmtTranslator::translateReturnStmt(const swift::ReturnStmt& stmt) {
  auto entry = dispatcher_.createEntry(stmt);
  if (stmt.hasResult()) {
    entry.result = dispatcher_.fetchLabel(stmt.getResult());
  }
  return entry;
}

codeql::ForEachStmt StmtTranslator::translateForEachStmt(const swift::ForEachStmt& stmt) {
  auto entry = dispatcher_.createEntry(stmt);
  fillLabeledStmt(stmt, entry);
  entry.body = dispatcher_.fetchLabel(stmt.getBody());
  entry.sequence = dispatcher_.fetchLabel(stmt.getParsedSequence());
  entry.pattern = dispatcher_.fetchLabel(stmt.getPattern());
  entry.where = dispatcher_.fetchOptionalLabel(stmt.getWhere());
  return entry;
}

codeql::IfStmt StmtTranslator::translateIfStmt(const swift::IfStmt& stmt) {
  auto entry = dispatcher_.createEntry(stmt);
  fillLabeledConditionalStmt(stmt, entry);
  entry.then = dispatcher_.fetchLabel(stmt.getThenStmt());
  entry.else_ = dispatcher_.fetchOptionalLabel(stmt.getElseStmt());
  return entry;
}

codeql::BreakStmt StmtTranslator::translateBreakStmt(const swift::BreakStmt& stmt) {
  auto entry = dispatcher_.createEntry(stmt);
  entry.target = dispatcher_.fetchOptionalLabel(stmt.getTarget());
  if (auto targetName = stmt.getTargetName(); !targetName.empty()) {
    entry.target_name = targetName.str().str();
  }
  return entry;
}

codeql::ContinueStmt StmtTranslator::translateContinueStmt(const swift::ContinueStmt& stmt) {
  auto entry = dispatcher_.createEntry(stmt);
  entry.target = dispatcher_.fetchOptionalLabel(stmt.getTarget());
  if (auto targetName = stmt.getTargetName(); !targetName.empty()) {
    entry.target_name = targetName.str().str();
  }
  return entry;
}

codeql::WhileStmt StmtTranslator::translateWhileStmt(const swift::WhileStmt& stmt) {
  auto entry = dispatcher_.createEntry(stmt);
  fillLabeledConditionalStmt(stmt, entry);
  entry.body = dispatcher_.fetchLabel(stmt.getBody());
  return entry;
}

codeql::RepeatWhileStmt StmtTranslator::translateRepeatWhileStmt(
    const swift::RepeatWhileStmt& stmt) {
  auto entry = dispatcher_.createEntry(stmt);
  fillLabeledStmt(stmt, entry);
  entry.body = dispatcher_.fetchLabel(stmt.getBody());
  entry.condition = dispatcher_.fetchLabel(stmt.getCond());
  return entry;
}

codeql::DoCatchStmt StmtTranslator::translateDoCatchStmt(const swift::DoCatchStmt& stmt) {
  auto entry = dispatcher_.createEntry(stmt);
  fillLabeledStmt(stmt, entry);
  entry.body = dispatcher_.fetchLabel(stmt.getBody());
  entry.catches = dispatcher_.fetchRepeatedLabels(stmt.getCatches());
  return entry;
}

codeql::CaseStmt StmtTranslator::translateCaseStmt(const swift::CaseStmt& stmt) {
  auto entry = dispatcher_.createEntry(stmt);
  entry.body = dispatcher_.fetchLabel(stmt.getBody());
  entry.labels = dispatcher_.fetchRepeatedLabels(stmt.getCaseLabelItems());
  if (stmt.hasCaseBodyVariables()) {
    for (auto var : stmt.getCaseBodyVariables()) {
      entry.variables.push_back(dispatcher_.fetchLabel(var));
    }
  }
  return entry;
}

codeql::GuardStmt StmtTranslator::translateGuardStmt(const swift::GuardStmt& stmt) {
  auto entry = dispatcher_.createEntry(stmt);
  fillLabeledConditionalStmt(stmt, entry);
  entry.body = dispatcher_.fetchLabel(stmt.getBody());
  return entry;
}

codeql::ThrowStmt StmtTranslator::translateThrowStmt(const swift::ThrowStmt& stmt) {
  auto entry = dispatcher_.createEntry(stmt);
  entry.sub_expr = dispatcher_.fetchLabel(stmt.getSubExpr());
  return entry;
}

codeql::DeferStmt StmtTranslator::translateDeferStmt(const swift::DeferStmt& stmt) {
  auto entry = dispatcher_.createEntry(stmt);
  entry.body = dispatcher_.fetchLabel(stmt.getBodyAsWritten());
  return entry;
}

codeql::DoStmt StmtTranslator::translateDoStmt(const swift::DoStmt& stmt) {
  auto entry = dispatcher_.createEntry(stmt);
  fillLabeledStmt(stmt, entry);
  entry.body = dispatcher_.fetchLabel(stmt.getBody());
  return entry;
}

codeql::SwitchStmt StmtTranslator::translateSwitchStmt(const swift::SwitchStmt& stmt) {
  auto entry = dispatcher_.createEntry(stmt);
  fillLabeledStmt(stmt, entry);
  entry.expr = dispatcher_.fetchLabel(stmt.getSubjectExpr());
  entry.cases = dispatcher_.fetchRepeatedLabels(stmt.getCases());
  return entry;
}

codeql::FallthroughStmt StmtTranslator::translateFallthroughStmt(
    const swift::FallthroughStmt& stmt) {
  auto entry = dispatcher_.createEntry(stmt);
  entry.fallthrough_source = dispatcher_.fetchLabel(stmt.getFallthroughSource());
  entry.fallthrough_dest = dispatcher_.fetchLabel(stmt.getFallthroughDest());
  return entry;
}

codeql::YieldStmt StmtTranslator::translateYieldStmt(const swift::YieldStmt& stmt) {
  auto entry = dispatcher_.createEntry(stmt);
  entry.results = dispatcher_.fetchRepeatedLabels(stmt.getYields());
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
      dispatcher_.fetchLabel(const_cast<swift::LabeledConditionalStmt&>(stmt).getCondPointer());
  fillLabeledStmt(stmt, entry);
}

}  // namespace codeql
