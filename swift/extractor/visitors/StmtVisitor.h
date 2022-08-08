#pragma once

#include "swift/extractor/visitors/VisitorBase.h"
#include "swift/extractor/trap/generated/stmt/TrapClasses.h"

namespace codeql {

class StmtVisitor : public AstVisitorBase<StmtVisitor> {
 public:
  using AstVisitorBase<StmtVisitor>::AstVisitorBase;

  void visitLabeledStmt(swift::LabeledStmt* stmt);
  codeql::StmtCondition translateStmtCondition(const swift::StmtCondition& cond);
  codeql::ConditionElement translateStmtConditionElement(
      const swift::StmtConditionElement& element);
  void visitLabeledConditionalStmt(swift::LabeledConditionalStmt* stmt);
  void visitCaseLabelItem(swift::CaseLabelItem* labelItem);
  void visitBraceStmt(swift::BraceStmt* stmt);
  void visitReturnStmt(swift::ReturnStmt* stmt);
  void visitForEachStmt(swift::ForEachStmt* stmt);
  void visitIfStmt(swift::IfStmt* stmt);
  void visitBreakStmt(swift::BreakStmt* stmt);
  void visitContinueStmt(swift::ContinueStmt* stmt);
  void visitWhileStmt(swift::WhileStmt* stmt);
  void visitRepeatWhileStmt(swift::RepeatWhileStmt* stmt);
  void visitDoCatchStmt(swift::DoCatchStmt* stmt);
  void visitCaseStmt(swift::CaseStmt* stmt);
  void visitGuardStmt(swift::GuardStmt* stmt);
  void visitThrowStmt(swift::ThrowStmt* stmt);
  void visitDeferStmt(swift::DeferStmt* stmt);
  void visitDoStmt(swift::DoStmt* stmt);
  void visitSwitchStmt(swift::SwitchStmt* stmt);
  void visitFallthroughStmt(swift::FallthroughStmt* stmt);
  void visitYieldStmt(swift::YieldStmt* stmt);

 private:
  void emitLabeledStmt(const swift::LabeledStmt* stmt, TrapLabel<LabeledStmtTag> label);
  void emitLabeledConditionalStmt(swift::LabeledConditionalStmt* stmt,
                                  TrapLabel<LabeledConditionalStmtTag> label);
};

}  // namespace codeql
