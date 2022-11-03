#pragma once

#include "swift/extractor/infra/SwiftDispatcher.h"
#include "swift/extractor/translators/DeclTranslator.h"
#include "swift/extractor/translators/ExprTranslator.h"
#include "swift/extractor/translators/StmtTranslator.h"
#include "swift/extractor/translators/TypeTranslator.h"
#include "swift/extractor/translators/PatternTranslator.h"

namespace codeql {

class SwiftVisitor : private SwiftDispatcher {
 public:
  using SwiftDispatcher::getEncounteredModules;
  using SwiftDispatcher::SwiftDispatcher;

  template <typename T>
  void extract(const T& entity) {
    fetchLabel(entity);
  }
  void extract(swift::Token& comment) { emitComment(comment); }

 private:
  void visit(const swift::Decl* decl) override { declTranslator.visit(decl); }
  void visit(const swift::Stmt* stmt) override { stmtTranslator.visit(stmt); }
  void visit(const swift::StmtCondition* cond) override {
    emit(stmtTranslator.translateStmtCondition(*cond));
  }
  void visit(const swift::StmtConditionElement* element) override {
    emit(stmtTranslator.translateStmtConditionElement(*element));
  }
  void visit(const swift::CaseLabelItem* item) override {
    emit(stmtTranslator.translateCaseLabelItem(*item));
  }
  void visit(const swift::Expr* expr) override { exprTranslator.visit(expr); }
  void visit(const swift::Pattern* pattern) override { patternTranslator.visit(pattern); }
  void visit(swift::TypeBase* type) override { typeTranslator.visit(type); }
  void visit(const swift::TypeRepr* typeRepr, swift::Type type) override {
    emit(typeTranslator.translateTypeRepr(*typeRepr, type));
  }

  DeclTranslator declTranslator{*this};
  ExprTranslator exprTranslator{*this};
  StmtTranslator stmtTranslator{*this};
  TypeTranslator typeTranslator{*this};
  PatternTranslator patternTranslator{*this};
};

}  // namespace codeql
