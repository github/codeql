#pragma once

#include "swift/extractor/SwiftDispatcher.h"
#include <swift/AST/ASTVisitor.h>

namespace codeql {

namespace detail {
// swift code lacks default implementations of visitor for some entities. We can add those here
// while we do not have yet all implemented. This is a simplified version of the corresponding Expr
// code in swift/AST/ASTVisitor.h
template <typename CrtpSubclass>
class PatchedStmtVisitor : public swift::StmtVisitor<CrtpSubclass> {
 public:
#define ABSTRACT_STMT(CLASS, PARENT)                           \
  void visit##CLASS##Stmt(swift::CLASS##Stmt* E) {             \
    return static_cast<CrtpSubclass*>(this)->visit##PARENT(E); \
  }
#define STMT(CLASS, PARENT) ABSTRACT_STMT(CLASS, PARENT)
#include "swift/AST/StmtNodes.def"
};

}  // namespace detail

class StmtVisitor : public detail::PatchedStmtVisitor<StmtVisitor> {
 public:
  // SwiftDispatcher should outlive the StmtVisitor
  StmtVisitor(SwiftDispatcher& dispatcher) : dispatcher(dispatcher) {}

  template <typename E>
  void visitStmt(E* stmt) {
    dispatcher.TBD<swift::Stmt>(stmt, "Stmt");
  }

 private:
  SwiftDispatcher& dispatcher;
};

}  // namespace codeql
