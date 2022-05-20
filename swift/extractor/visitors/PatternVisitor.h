#pragma once

#include "swift/extractor/SwiftDispatcher.h"
#include <swift/AST/ASTVisitor.h>

namespace codeql {

namespace detail {
// swift code lacks default implementations of visitor for some entities. We can add those here
// while we do not have yet all implemented. This is a simplified version of the corresponding Expr
// code in swift/AST/ASTVisitor.h
template <typename CrtpSubclass>
class PatchedPatternVisitor : public swift::PatternVisitor<CrtpSubclass> {
 public:
#define PATTERN(CLASS, PARENT)                                 \
  void visit##CLASS##Pattern(swift::CLASS##Pattern* E) {       \
    return static_cast<CrtpSubclass*>(this)->visit##PARENT(E); \
  }
#include "swift/AST/PatternNodes.def"
};

}  // namespace detail

class PatternVisitor : public detail::PatchedPatternVisitor<PatternVisitor> {
 public:
  // SwiftDispatcher should outlive the PatternVisitor
  PatternVisitor(SwiftDispatcher& dispatcher) : dispatcher(dispatcher) {}

  template <typename E>
  void visitPattern(E* pattern) {
    dispatcher.TBD<swift::Pattern>(pattern, "Pattern");
  }

 private:
  SwiftDispatcher& dispatcher;
};

}  // namespace codeql
