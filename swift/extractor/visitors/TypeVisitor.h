#pragma once

#include "swift/extractor/SwiftDispatcher.h"
#include <swift/AST/TypeVisitor.h>

namespace codeql {

class TypeVisitor : public swift::TypeVisitor<TypeVisitor> {
 public:
  TypeVisitor(SwiftDispatcher& dispatcher) : dispatcher(dispatcher) {}

  template <typename E>
  void visitType(E* type) {
    dispatcher.TBD<swift::TypeBase>(type, "Type");
  }

 private:
  SwiftDispatcher& dispatcher;
};

}  // namespace codeql
