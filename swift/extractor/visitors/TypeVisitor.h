#pragma once

#include "swift/extractor/SwiftDispatcher.h"
#include <swift/AST/TypeVisitor.h>

namespace codeql {

class TypeVisitor : public swift::TypeVisitor<TypeVisitor> {
 public:
  // SwiftDispatcher should outlive the TypeVisitor
  TypeVisitor(SwiftDispatcher& dispatcher) : dispatcher(dispatcher) {}

  template <typename E>
  void visitType(E* type) {
    dispatcher.TBD<swift::TypeBase>(type, "Type");
  }

 private:
  SwiftDispatcher& dispatcher;
};

}  // namespace codeql
