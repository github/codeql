#pragma once

#include "swift/extractor/SwiftDispatcher.h"
#include <swift/AST/ASTVisitor.h>

namespace codeql {

class DeclVisitor : public swift::DeclVisitor<DeclVisitor> {
 public:
  DeclVisitor(SwiftDispatcher& dispatcher) : dispatcher(dispatcher) {}

  template <typename E>
  void visitDecl(E* decl) {
    dispatcher.TBD<swift::Decl>(decl, "Decl");
  }

 private:
  SwiftDispatcher& dispatcher;
};

}  // namespace codeql
