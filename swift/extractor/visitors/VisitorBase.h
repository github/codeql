#pragma once

#include <swift/AST/ASTVisitor.h>
#include <swift/AST/TypeVisitor.h>

#include "swift/extractor/SwiftDispatcher.h"

namespace codeql {

namespace detail {
class VisitorBase {
 protected:
  SwiftDispatcher& dispatcher_;

 public:
  // SwiftDispatcher should outlive this instance
  VisitorBase(SwiftDispatcher& dispatcher) : dispatcher_{dispatcher} {}

 protected:
  template <typename Trap, typename... Args>
  void emit(Args&&... args) {
    dispatcher_.emit(Trap{resolve(args, 0)...});
  }

  template <typename Trap, typename Tag, typename Range>
  void emitRepeated(TrapLabel<Tag> label, Range&& range) {
    auto i = 0u;
    for (const auto& e : range) {
      emit<Trap>(label, i++, e);
    }
  }

  template <typename Trap, typename Tag, typename Arg>
  void emitOptional(TrapLabel<Tag> label, Arg&& arg) {
    if (arg) {
      emit<Trap>(label, std::forward<Arg>(arg));
    }
  }

 private:
  template <typename Arg>
  auto resolve(Arg&& arg, int) -> decltype(dispatcher_.fetchLabel(std::forward<Arg>(arg))) {
    return dispatcher_.fetchLabel(std::forward<Arg>(arg));
  }

  template <typename Arg>
  Arg&& resolve(Arg&& arg, double) {
    return std::forward<Arg>(arg);
  }
};

}  // namespace detail

// we want to override the default swift visitor behaviour of chaining calls to immediate
// superclasses by default and instead provide our own TBD default (using the exact type)
#define DEFAULT(KIND, CLASS, PARENT) \
  void visit##CLASS##KIND(swift::CLASS##KIND* e) { dispatcher_.emitUnknown(e); }

// base class for our AST visitors, getting a SwiftDispatcher member and default emission for
// unknown/TBD entities. Like `swift::ASTVisitor`, this uses CRTP (the Curiously Recurring Template
// Pattern)
template <typename CrtpSubclass>
class AstVisitorBase : public swift::ASTVisitor<CrtpSubclass>, protected detail::VisitorBase {
 public:
  using VisitorBase::VisitorBase;

#define DECL(CLASS, PARENT) DEFAULT(Decl, CLASS, PARENT)
#include "swift/AST/DeclNodes.def"

#define STMT(CLASS, PARENT) DEFAULT(Stmt, CLASS, PARENT)
#include "swift/AST/StmtNodes.def"

#define EXPR(CLASS, PARENT) DEFAULT(Expr, CLASS, PARENT)
#include "swift/AST/ExprNodes.def"

#define PATTERN(CLASS, PARENT) DEFAULT(Pattern, CLASS, PARENT)
#include "swift/AST/PatternNodes.def"

#define TYPEREPR(CLASS, PARENT) DEFAULT(TypeRepr, CLASS, PARENT)
#include "swift/AST/TypeReprNodes.def"
};

// base class for our type visitor, getting a SwiftDispatcher member and default emission for
// unknown/TBD types. Like `swift::TypeVisitor`, this uses CRTP (the Curiously Recurring Template
// Pattern)
template <typename CrtpSubclass>
class TypeVisitorBase : public swift::TypeVisitor<CrtpSubclass>, protected detail::VisitorBase {
 public:
  using VisitorBase::VisitorBase;

#define TYPE(CLASS, PARENT) DEFAULT(Type, CLASS, PARENT)
#include "swift/AST/TypeNodes.def"
};

#undef DEFAULT

}  // namespace codeql
