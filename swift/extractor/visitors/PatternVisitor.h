#pragma once

#include "swift/extractor/SwiftDispatcher.h"
#include <swift/AST/ASTVisitor.h>

namespace codeql {

// swift code lacks default implementations of visitor for some entities. We can add those here
// while we do not have yet all implemented. This is copy and pasted from the corresponding Expr
// code in swift/AST/ASTVisitor.h
template <typename ImplClass, typename PatternRetTy = void, typename... Args>
class PatchedPatternVisitor : public swift::PatternVisitor<ImplClass, PatternRetTy, Args...> {
 public:
#define PATTERN(CLASS, PARENT)                                                           \
  PatternRetTy visit##CLASS##Pattern(swift::CLASS##Pattern* E, Args... AA) {             \
    return static_cast<ImplClass*>(this)->visit##PARENT(E, ::std::forward<Args>(AA)...); \
  }
#include "swift/AST/PatternNodes.def"
};

class PatternVisitor : public PatchedPatternVisitor<PatternVisitor> {
 public:
  PatternVisitor(SwiftDispatcher& dispatcher) : dispatcher(dispatcher) {}

  template <typename E>
  void visitPattern(E* pattern) {
    dispatcher.TBD<swift::Pattern>(pattern, "Pattern");
  }

 private:
  SwiftDispatcher& dispatcher;
};

}  // namespace codeql
