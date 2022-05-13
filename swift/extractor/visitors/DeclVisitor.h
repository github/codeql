#pragma once

#include "swift/extractor/SwiftDispatcher.h"
#include <swift/AST/ASTVisitor.h>

namespace codeql {

class DeclVisitor : public swift::DeclVisitor<DeclVisitor> {
 public:
  // SwiftDispatcher should outlive the DeclVisitor
  DeclVisitor(SwiftDispatcher& dispatcher) : dispatcher(dispatcher) {}

  template <typename E>
  void visitDecl(E* decl) {
    dispatcher.TBD<swift::Decl>(decl, "Decl");
  }

 private:
  SwiftDispatcher& dispatcher;
};

}  // namespace codeql
