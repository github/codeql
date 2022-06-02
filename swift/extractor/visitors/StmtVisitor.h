#pragma once

#include "swift/extractor/visitors/VisitorBase.h"

namespace codeql {

class StmtVisitor : public AstVisitorBase<StmtVisitor> {
 public:
  using AstVisitorBase<StmtVisitor>::AstVisitorBase;

  void visitLabeledStmt(swift::LabeledStmt* stmt) {
    auto label = dispatcher_.assignNewLabel(stmt);
    emitLabeledStmt(stmt, label);
  }

  void visitStmtCondition(swift::StmtCondition* cond) {
    auto label = dispatcher_.assignNewLabel(cond);
    dispatcher_.emit(StmtConditionsTrap{label});
    unsigned index = 0;
    for (const auto& cond : *cond) {
      auto condLabel = dispatcher_.createLabel<ConditionElementTag>();
      dispatcher_.attachLocation(cond, condLabel);
      dispatcher_.emit(ConditionElementsTrap{condLabel});
      dispatcher_.emit(StmtConditionElementsTrap{label, index++, condLabel});
      if (auto boolean = cond.getBooleanOrNull()) {
        auto elementLabel = dispatcher_.fetchLabel(boolean);
        dispatcher_.emit(ConditionElementBooleansTrap{condLabel, elementLabel});
      } else if (auto pattern = cond.getPatternOrNull()) {
        auto patternLabel = dispatcher_.fetchLabel(pattern);
        auto initilizerLabel = dispatcher_.fetchLabel(cond.getInitializer());
        dispatcher_.emit(ConditionElementPatternsTrap{condLabel, patternLabel});
        dispatcher_.emit(ConditionElementInitializersTrap{condLabel, initilizerLabel});
      }
      /// TODO: Implement availability
    }
  }

  void visitLabeledConditionalStmt(swift::LabeledConditionalStmt* stmt) {
    auto label = dispatcher_.assignNewLabel(stmt);
    emitLabeledStmt(stmt, label);
    emitLabeledConditionalStmt(stmt, label);
  }

  void visitCaseLabelItem(swift::CaseLabelItem* labelItem) {
    auto label = dispatcher_.assignNewLabel(labelItem);
    assert(labelItem->getPattern() && "CaseLabelItem has Pattern");
    dispatcher_.emit(CaseLabelItemsTrap{label, dispatcher_.fetchLabel(labelItem->getPattern())});
  }

  void visitBraceStmt(swift::BraceStmt* stmt) {
    auto label = dispatcher_.assignNewLabel(stmt);
    dispatcher_.emit(BraceStmtsTrap{label});
    auto i = 0u;
    for (auto& e : stmt->getElements()) {
      dispatcher_.emit(BraceStmtElementsTrap{label, i++, dispatcher_.fetchLabel(e)});
    }
  }

  void visitReturnStmt(swift::ReturnStmt* stmt) {
    auto label = dispatcher_.assignNewLabel(stmt);
    dispatcher_.emit(ReturnStmtsTrap{label});
    if (stmt->hasResult()) {
      auto resultLabel = dispatcher_.fetchLabel(stmt->getResult());
      dispatcher_.emit(ReturnStmtResultsTrap{label, resultLabel});
    }
  }

  void visitForEachStmt(swift::ForEachStmt* stmt) {
    auto label = dispatcher_.assignNewLabel(stmt);
    assert(stmt->getBody() && "ForEachStmt has getBody()");
    assert(stmt->getSequence() && "ForEachStmt has getSequence()");
    assert(stmt->getPattern() && "ForEachStmt has getPattern()");
    auto bodyLabel = dispatcher_.fetchLabel(stmt->getBody());
    auto sequenceLabel = dispatcher_.fetchLabel(stmt->getSequence());
    auto patternLabel = dispatcher_.fetchLabel(stmt->getPattern());
    emitLabeledStmt(stmt, label);
    dispatcher_.emit(ForEachStmtsTrap{label, patternLabel, sequenceLabel, bodyLabel});
    if (auto where = stmt->getWhere()) {
      auto whereLabel = dispatcher_.fetchLabel(where);
      dispatcher_.emit(ForEachStmtWheresTrap{label, whereLabel});
    }
  }

  void visitIfStmt(swift::IfStmt* stmt) {
    auto label = dispatcher_.assignNewLabel(stmt);
    emitLabeledStmt(stmt, label);
    emitLabeledConditionalStmt(stmt, label);
    auto thenLabel = dispatcher_.fetchLabel(stmt->getThenStmt());
    dispatcher_.emit(IfStmtsTrap{label, thenLabel});
    if (auto* elseStmt = stmt->getElseStmt()) {
      auto elseLabel = dispatcher_.fetchLabel(elseStmt);
      dispatcher_.emit(IfStmtElsesTrap{label, elseLabel});
    }
  }

  void visitBreakStmt(swift::BreakStmt* stmt) {
    auto label = dispatcher_.assignNewLabel(stmt);
    dispatcher_.emit(BreakStmtsTrap{label});
    if (auto* target = stmt->getTarget()) {
      auto targetlabel = dispatcher_.fetchLabel(target);
      dispatcher_.emit(BreakStmtTargetsTrap{label, targetlabel});
    }
    auto targetName = stmt->getTargetName();
    if (!targetName.empty()) {
      dispatcher_.emit(BreakStmtTargetNamesTrap{label, targetName.str().str()});
    }
  }

  void visitContinueStmt(swift::ContinueStmt* stmt) {
    auto label = dispatcher_.assignNewLabel(stmt);
    dispatcher_.emit(ContinueStmtsTrap{label});
    if (auto* target = stmt->getTarget()) {
      auto targetlabel = dispatcher_.fetchLabel(target);
      dispatcher_.emit(ContinueStmtTargetsTrap{label, targetlabel});
    }
    auto targetName = stmt->getTargetName();
    if (!targetName.empty()) {
      dispatcher_.emit(ContinueStmtTargetNamesTrap{label, targetName.str().str()});
    }
  }

  void visitWhileStmt(swift::WhileStmt* stmt) {
    auto label = dispatcher_.assignNewLabel(stmt);
    emitLabeledStmt(stmt, label);
    emitLabeledConditionalStmt(stmt, label);
    dispatcher_.emit(WhileStmtsTrap{label, dispatcher_.fetchLabel(stmt->getBody())});
  }

  void visitRepeatWhileStmt(swift::RepeatWhileStmt* stmt) {
    auto label = dispatcher_.assignNewLabel(stmt);
    emitLabeledStmt(stmt, label);
    auto bodyLabel = dispatcher_.fetchLabel(stmt->getBody());
    auto condLabel = dispatcher_.fetchLabel(stmt->getCond());
    dispatcher_.emit(RepeatWhileStmtsTrap{label, condLabel, bodyLabel});
  }

  void visitDoCatchStmt(swift::DoCatchStmt* stmt) {
    auto label = dispatcher_.assignNewLabel(stmt);
    emitLabeledStmt(stmt, label);
    auto bodyLabel = dispatcher_.fetchLabel(stmt->getBody());
    dispatcher_.emit(DoCatchStmtsTrap{label, bodyLabel});
    auto i = 0u;
    for (auto* stmtCatch : stmt->getCatches()) {
      dispatcher_.emit(DoCatchStmtCatchesTrap{label, i++, dispatcher_.fetchLabel(stmtCatch)});
    }
  }

  void visitCaseStmt(swift::CaseStmt* stmt) {
    auto label = dispatcher_.assignNewLabel(stmt);
    auto bodyLabel = dispatcher_.fetchLabel(stmt->getBody());
    dispatcher_.emit(CaseStmtsTrap{label, bodyLabel});
    auto i = 0u;
    for (auto& item : stmt->getMutableCaseLabelItems()) {
      dispatcher_.emit(CaseStmtLabelsTrap{label, i++, dispatcher_.fetchLabel(&item)});
    }
    if (stmt->hasCaseBodyVariables()) {
      auto i = 0u;
      for (auto* var : stmt->getCaseBodyVariables()) {
        dispatcher_.emit(CaseStmtVariablesTrap{label, i++, dispatcher_.fetchLabel(var)});
      }
    }
  }

  void visitGuardStmt(swift::GuardStmt* stmt) {
    auto label = dispatcher_.assignNewLabel(stmt);
    emitLabeledStmt(stmt, label);
    emitLabeledConditionalStmt(stmt, label);
    auto bodyLabel = dispatcher_.fetchLabel(stmt->getBody());
    dispatcher_.emit(GuardStmtsTrap{label, bodyLabel});
  }

  void visitThrowStmt(swift::ThrowStmt* stmt) {
    auto label = dispatcher_.assignNewLabel(stmt);
    auto subExprLabel = dispatcher_.fetchLabel(stmt->getSubExpr());
    dispatcher_.emit(ThrowStmtsTrap{label, subExprLabel});
  }

  void visitDeferStmt(swift::DeferStmt* stmt) {
    auto label = dispatcher_.assignNewLabel(stmt);
    auto bodyLabel = dispatcher_.fetchLabel(stmt->getBodyAsWritten());
    dispatcher_.emit(DeferStmtsTrap{label, bodyLabel});
  }

  void visitDoStmt(swift::DoStmt* stmt) {
    auto label = dispatcher_.assignNewLabel(stmt);
    emitLabeledStmt(stmt, label);
    auto bodyLabel = dispatcher_.fetchLabel(stmt->getBody());
    dispatcher_.emit(DoStmtsTrap{label, bodyLabel});
  }

  void visitSwitchStmt(swift::SwitchStmt* stmt) {
    auto label = dispatcher_.assignNewLabel(stmt);
    emitLabeledStmt(stmt, label);
    auto subjectLabel = dispatcher_.fetchLabel(stmt->getSubjectExpr());
    dispatcher_.emit(SwitchStmtsTrap{label, subjectLabel});
    auto i = 0u;
    for (auto* c : stmt->getCases()) {
      dispatcher_.emit(SwitchStmtCasesTrap{label, i++, dispatcher_.fetchLabel(c)});
    }
  }

  void visitFallthroughStmt(swift::FallthroughStmt* stmt) {
    auto label = dispatcher_.assignNewLabel(stmt);
    auto sourceLabel = dispatcher_.fetchLabel(stmt->getFallthroughSource());
    auto destLabel = dispatcher_.fetchLabel(stmt->getFallthroughDest());
    dispatcher_.emit(FallthroughStmtsTrap{label, sourceLabel, destLabel});
  }

  void visitYieldStmt(swift::YieldStmt* stmt) {
    auto label = dispatcher_.assignNewLabel(stmt);
    dispatcher_.emit(YieldStmtsTrap{label});
    auto i = 0u;
    for(auto* expr : stmt->getYields()) {
      auto exprLabel = dispatcher_.fetchLabel(expr);
      dispatcher_.emit(YieldStmtResultsTrap{label, i++, exprLabel});
    }
  }

 private:
  void emitLabeledStmt(const swift::LabeledStmt* stmt, TrapLabel<LabeledStmtTag> label) {
    if (stmt->getLabelInfo()) {
      dispatcher_.emit(LabeledStmtLabelsTrap{label, stmt->getLabelInfo().Name.str().str()});
    }
  }

  void emitLabeledConditionalStmt(swift::LabeledConditionalStmt* stmt,
                                  TrapLabel<LabeledConditionalStmtTag> label) {
    auto condLabel = dispatcher_.fetchLabel(stmt->getCondPointer());
    dispatcher_.emit(LabeledConditionalStmtsTrap{label, condLabel});
  }
};

}  // namespace codeql
