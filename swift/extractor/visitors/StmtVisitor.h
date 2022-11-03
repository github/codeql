#pragma once

#include "swift/extractor/visitors/VisitorBase.h"
#include "swift/extractor/trap/generated/stmt/TrapClasses.h"

namespace codeql {

class StmtVisitor : public AstVisitorBase<StmtVisitor> {
 public:
  using AstVisitorBase<StmtVisitor>::AstVisitorBase;

  codeql::StmtCondition translateStmtCondition(const swift::StmtCondition& cond);
  codeql::ConditionElement translateStmtConditionElement(
      const swift::StmtConditionElement& element);
  codeql::CaseLabelItem translateCaseLabelItem(const swift::CaseLabelItem& labelItem);
  codeql::BraceStmt translateBraceStmt(const swift::BraceStmt& stmt);
  codeql::ReturnStmt translateReturnStmt(const swift::ReturnStmt& stmt);
  codeql::ForEachStmt translateForEachStmt(const swift::ForEachStmt& stmt);
  codeql::IfStmt translateIfStmt(const swift::IfStmt& stmt);
  codeql::BreakStmt translateBreakStmt(const swift::BreakStmt& stmt);
  codeql::ContinueStmt translateContinueStmt(const swift::ContinueStmt& stmt);
  codeql::WhileStmt translateWhileStmt(const swift::WhileStmt& stmt);
  codeql::RepeatWhileStmt translateRepeatWhileStmt(const swift::RepeatWhileStmt& stmt);
  codeql::DoCatchStmt translateDoCatchStmt(const swift::DoCatchStmt& stmt);
  codeql::CaseStmt translateCaseStmt(const swift::CaseStmt& stmt);
  codeql::GuardStmt translateGuardStmt(const swift::GuardStmt& stmt);
  codeql::ThrowStmt translateThrowStmt(const swift::ThrowStmt& stmt);
  codeql::DeferStmt translateDeferStmt(const swift::DeferStmt& stmt);
  codeql::DoStmt translateDoStmt(const swift::DoStmt& stmt);
  codeql::SwitchStmt translateSwitchStmt(const swift::SwitchStmt& stmt);
  codeql::FallthroughStmt translateFallthroughStmt(const swift::FallthroughStmt& stmt);
  codeql::YieldStmt translateYieldStmt(const swift::YieldStmt& stmt);

 private:
  void fillLabeledStmt(const swift::LabeledStmt& stmt, codeql::LabeledStmt& entry);
  void fillLabeledConditionalStmt(const swift::LabeledConditionalStmt& stmt,
                                  codeql::LabeledConditionalStmt& entry);
};

}  // namespace codeql
