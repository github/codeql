#pragma once

#include "swift/extractor/translators/TranslatorBase.h"
#include "swift/extractor/trap/generated/stmt/TrapClasses.h"

namespace codeql {

class StmtTranslator : public AstTranslatorBase<StmtTranslator> {
 public:
  static constexpr std::string_view name = "stmt";

  using AstTranslatorBase<StmtTranslator>::AstTranslatorBase;
  using AstTranslatorBase<StmtTranslator>::translateAndEmit;

  void translateAndEmit(const swift::StmtCondition& cond);
  void translateAndEmit(const swift::StmtConditionElement& element);
  void translateAndEmit(const swift::CaseLabelItem& labelItem);
  void translateAndEmit(const swift::PoundAvailableInfo& availability);
  void translateAndEmit(const swift::AvailabilitySpec& spec);
  void translateAndEmit(const swift::PlatformVersionConstraintAvailabilitySpec& spec);
  void translateAndEmit(const swift::OtherPlatformAvailabilitySpec& spec);

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
  codeql::FailStmt translateFailStmt(const swift::FailStmt& stmt);
  codeql::PoundAssertStmt translatePoundAssertStmt(const swift::PoundAssertStmt& stmt);
  codeql::DiscardStmt translateDiscardStmt(const swift::DiscardStmt& stmt);
  codeql::ThenStmt translateThenStmt(const swift::ThenStmt& stmt);

 private:
  void fillLabeledStmt(const swift::LabeledStmt& stmt, codeql::LabeledStmt& entry);
  void fillLabeledConditionalStmt(const swift::LabeledConditionalStmt& stmt,
                                  codeql::LabeledConditionalStmt& entry);
};

}  // namespace codeql
