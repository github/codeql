#pragma once

#include "swift/extractor/SwiftDispatcher.h"
#include <swift/AST/ASTVisitor.h>

namespace codeql {

// swift code lacks default implementations of visitor for some entities. We can add those here
// while we do not have yet all implemented. This is copy and pasted from the corresponding Expr
// code in swift/AST/ASTVisitor.h
template <typename ImplClass, typename StmtRetTy = void, typename... Args>
class PatchedStmtVisitor : public swift::StmtVisitor<ImplClass, StmtRetTy, Args...> {
 public:
#define ABSTRACT_STMT(CLASS, PARENT)                                                     \
  StmtRetTy visit##CLASS##Stmt(swift::CLASS##Stmt* E, Args... AA) {                      \
    return static_cast<ImplClass*>(this)->visit##PARENT(E, ::std::forward<Args>(AA)...); \
  }
#define STMT(CLASS, PARENT) ABSTRACT_STMT(CLASS, PARENT)
#include "swift/AST/StmtNodes.def"
};

class StmtVisitor : public PatchedStmtVisitor<StmtVisitor> {
 public:
  StmtVisitor(SwiftDispatcher& dispatcher) : dispatcher(dispatcher) {}

  template <typename E>
  void visitStmt(E* stmt) {
    dispatcher.TBD<swift::Stmt>(stmt, "Stmt");
  }

 private:
  SwiftDispatcher& dispatcher;
};

}  // namespace codeql
