#pragma once

#include "swift/extractor/SwiftDispatcher.h"
#include <swift/AST/ASTVisitor.h>

namespace codeql {

class ExprVisitor : public swift::ExprVisitor<ExprVisitor> {
 public:
  // SwiftDispatcher should outlive the ExprVisitor
  ExprVisitor(SwiftDispatcher& dispatcher) : dispatcher(dispatcher) {}

  template <typename E>
  void visitExpr(E* expr) {
    dispatcher.TBD<swift::Expr>(expr, "Expr");
  }

 private:
  SwiftDispatcher& dispatcher;
};

}  // namespace codeql
