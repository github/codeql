#pragma once

#include "swift/extractor/infra/SwiftDispatcher.h"
#include "swift/extractor/visitors/DeclVisitor.h"
#include "swift/extractor/visitors/ExprVisitor.h"
#include "swift/extractor/visitors/StmtVisitor.h"
#include "swift/extractor/visitors/TypeVisitor.h"
#include "swift/extractor/visitors/PatternVisitor.h"

namespace codeql {

class SwiftVisitor : private SwiftDispatcher {
 public:
  using SwiftDispatcher::SwiftDispatcher;

  template <typename T>
  void extract(const T& entity) {
    fetchLabel(entity);
  }
  void extract(swift::Token& comment) { emitComment(comment); }

 private:
  void visit(swift::Decl* decl) override { declVisitor.visit(decl); }
  void visit(const swift::IfConfigClause* clause) override { declVisitor.visit(clause); }
  void visit(swift::Stmt* stmt) override { stmtVisitor.visit(stmt); }
  void visit(const swift::StmtCondition* cond) override {
    emit(stmtVisitor.translateStmtCondition(*cond));
  }
  void visit(const swift::StmtConditionElement* element) override {
    emit(stmtVisitor.translateStmtConditionElement(*element));
  }
  void visit(swift::CaseLabelItem* item) override { stmtVisitor.visitCaseLabelItem(item); }
  void visit(swift::Expr* expr) override { exprVisitor.visit(expr); }
  void visit(swift::Pattern* pattern) override { patternVisitor.visit(pattern); }
  void visit(swift::TypeBase* type) override { typeVisitor.visit(type); }
  void visit(swift::TypeRepr* typeRepr, swift::Type type) override {
    emit(typeVisitor.translateTypeRepr(*typeRepr, type));
  }

  DeclVisitor declVisitor{*this};
  ExprVisitor exprVisitor{*this};
  StmtVisitor stmtVisitor{*this};
  TypeVisitor typeVisitor{*this};
  PatternVisitor patternVisitor{*this};
};

}  // namespace codeql
