#pragma once

#include "swift/extractor/infra/SwiftDispatcher.h"
#include "swift/extractor/translators/DeclTranslator.h"
#include "swift/extractor/translators/ExprTranslator.h"
#include "swift/extractor/translators/StmtTranslator.h"
#include "swift/extractor/translators/TypeTranslator.h"
#include "swift/extractor/translators/PatternTranslator.h"
#include "swift/extractor/mangler/SwiftMangler.h"

namespace codeql {

class SwiftVisitor : private SwiftDispatcher {
 public:
  using SwiftDispatcher::getEncounteredModules;
  using SwiftDispatcher::SwiftDispatcher;

  template <typename T>
  void extract(const T& entity) {
    fetchLabel(entity);
    visitPending();
  }
  void extract(swift::Token& comment) { emitComment(comment); }

 private:
  SwiftMangledName name(const swift::Decl* decl) override { return mangler.mangleDecl(*decl); }
  SwiftMangledName name(const swift::TypeBase* type) override { return mangler.mangleType(*type); }
  void visit(const swift::Decl* decl) override { declTranslator.translateAndEmit(*decl); }
  void visit(const swift::Stmt* stmt) override { stmtTranslator.translateAndEmit(*stmt); }
  void visit(const swift::StmtCondition* cond) override { stmtTranslator.translateAndEmit(*cond); }
  void visit(const swift::StmtConditionElement* element) override {
    stmtTranslator.translateAndEmit(*element);
  }
  void visit(const swift::PoundAvailableInfo* availability) override {
    stmtTranslator.translateAndEmit(*availability);
  }
  void visit(const swift::AvailabilitySpec* spec) override {
    stmtTranslator.translateAndEmit(*spec);
  }

  void visit(const swift::CaseLabelItem* item) override { stmtTranslator.translateAndEmit(*item); }
  void visit(const swift::Expr* expr) override { exprTranslator.translateAndEmit(*expr); }
  void visit(const swift::Pattern* pattern) override {
    patternTranslator.translateAndEmit(*pattern);
  }

  void visit(const swift::TypeBase* type) override { typeTranslator.translateAndEmit(*type); }
  void visit(const swift::TypeRepr* typeRepr, swift::Type type) override {
    typeTranslator.translateAndEmit(*typeRepr, type);
  }

  void visit(const swift::CapturedValue* capture) override {
    declTranslator.translateAndEmit(*capture);
  }

  void visit(const swift::MacroRoleAttr* attr) override { declTranslator.translateAndEmit(*attr); }

  DeclTranslator declTranslator{*this};
  ExprTranslator exprTranslator{*this};
  StmtTranslator stmtTranslator{*this};
  TypeTranslator typeTranslator{*this};
  PatternTranslator patternTranslator{*this};
  SwiftTrapMangler mangler{*this};
};

}  // namespace codeql
