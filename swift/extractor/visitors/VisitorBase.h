#pragma once

#include <swift/AST/ASTVisitor.h>
#include <swift/AST/TypeVisitor.h>

#include "swift/extractor/infra/SwiftDispatcher.h"

namespace codeql {

namespace detail {
class VisitorBase {
 protected:
  SwiftDispatcher& dispatcher_;

 public:
  // SwiftDispatcher should outlive this instance
  VisitorBase(SwiftDispatcher& dispatcher) : dispatcher_{dispatcher} {}
};

// define by macro metaprogramming member checkers
// see https://fekir.info/post/detect-member-variables/ for technical details
#define DEFINE_TRANSLATE_CHECKER(KIND, CLASS, PARENT)                                          \
  template <typename T, typename = void>                                                       \
  struct HasTranslate##CLASS##KIND : std::false_type {};                                       \
                                                                                               \
  template <typename T>                                                                        \
  struct HasTranslate##CLASS##KIND<T, decltype((void)std::declval<T>().translate##CLASS##KIND( \
                                                   std::declval<swift::CLASS##KIND&>()),       \
                                               void())> : std::true_type {};

DEFINE_TRANSLATE_CHECKER(Decl, , )
#define DECL(CLASS, PARENT) DEFINE_TRANSLATE_CHECKER(Decl, CLASS, PARENT)
#define ABSTRACT_DECL(CLASS, PARENT) DEFINE_TRANSLATE_CHECKER(Decl, CLASS, PARENT)
#include "swift/AST/DeclNodes.def"

DEFINE_TRANSLATE_CHECKER(Stmt, , )
#define STMT(CLASS, PARENT) DEFINE_TRANSLATE_CHECKER(Stmt, CLASS, PARENT)
#define ABSTRACT_STMT(CLASS, PARENT) DEFINE_TRANSLATE_CHECKER(Stmt, CLASS, PARENT)
#include "swift/AST/StmtNodes.def"

DEFINE_TRANSLATE_CHECKER(Expr, , )
#define EXPR(CLASS, PARENT) DEFINE_TRANSLATE_CHECKER(Expr, CLASS, PARENT)
#define ABSTRACT_EXPR(CLASS, PARENT) DEFINE_TRANSLATE_CHECKER(Expr, CLASS, PARENT)
#include "swift/AST/ExprNodes.def"

DEFINE_TRANSLATE_CHECKER(Pattern, , )
#define PATTERN(CLASS, PARENT) DEFINE_TRANSLATE_CHECKER(Pattern, CLASS, PARENT)
#include "swift/AST/PatternNodes.def"

DEFINE_TRANSLATE_CHECKER(Type, , )
#define TYPE(CLASS, PARENT) DEFINE_TRANSLATE_CHECKER(Type, CLASS, PARENT)
#define ABSTRACT_TYPE(CLASS, PARENT) DEFINE_TRANSLATE_CHECKER(Type, CLASS, PARENT)
#include "swift/AST/TypeNodes.def"

DEFINE_TRANSLATE_CHECKER(TypeRepr, , )
#define TYPEREPR(CLASS, PARENT) DEFINE_TRANSLATE_CHECKER(TypeRepr, CLASS, PARENT)
#define ABSTRACT_TYPEREPR(CLASS, PARENT) DEFINE_TRANSLATE_CHECKER(TypeRepr, CLASS, PARENT)
#include "swift/AST/TypeReprNodes.def"
}  // namespace detail

// we want to override the default swift visitor behaviour of chaining calls to immediate
// superclasses by default and instead provide our own TBD default (using the exact type).
// Moreover, if the implementation class has translate##CLASS##KIND (that uses generated C++
// classes), for the class of for a parent thereof, we want to use that. We detect that by using the
// type traits HasTranslate##CLASS##KIND defined above
#define DEFINE_VISIT(KIND, CLASS, PARENT)                                             \
 public:                                                                              \
  void visit##CLASS##KIND(swift::CLASS##KIND* e) {                                    \
    if constexpr (detail::HasTranslate##CLASS##KIND<CrtpSubclass>::value) {           \
      dispatcher_.emit(static_cast<CrtpSubclass*>(this)->translate##CLASS##KIND(*e)); \
    } else if constexpr (detail::HasTranslate##PARENT<CrtpSubclass>::value) {         \
      dispatcher_.emit(static_cast<CrtpSubclass*>(this)->translate##PARENT(*e));      \
    } else {                                                                          \
      dispatcher_.emitUnknown(e);                                                     \
    }                                                                                 \
  }

// base class for our AST visitors, getting a SwiftDispatcher member and define_visit emission for
// unknown/TBD entities. Like `swift::ASTVisitor`, this uses CRTP (the Curiously Recurring Template
// Pattern)
template <typename CrtpSubclass>
class AstVisitorBase : public swift::ASTVisitor<CrtpSubclass>, protected detail::VisitorBase {
 public:
  using VisitorBase::VisitorBase;

#define DECL(CLASS, PARENT) DEFINE_VISIT(Decl, CLASS, PARENT)
#include "swift/AST/DeclNodes.def"

#define STMT(CLASS, PARENT) DEFINE_VISIT(Stmt, CLASS, PARENT)
#include "swift/AST/StmtNodes.def"

#define EXPR(CLASS, PARENT) DEFINE_VISIT(Expr, CLASS, PARENT)
#include "swift/AST/ExprNodes.def"

#define PATTERN(CLASS, PARENT) DEFINE_VISIT(Pattern, CLASS, PARENT)
#include "swift/AST/PatternNodes.def"

#define TYPEREPR(CLASS, PARENT) DEFINE_VISIT(TypeRepr, CLASS, PARENT)
#include "swift/AST/TypeReprNodes.def"
};

// base class for our type visitor, getting a SwiftDispatcher member and define_visit emission for
// unknown/TBD types. Like `swift::TypeVisitor`, this uses CRTP (the Curiously Recurring Template
// Pattern)
template <typename CrtpSubclass>
class TypeVisitorBase : public swift::TypeVisitor<CrtpSubclass>, protected detail::VisitorBase {
 public:
  using VisitorBase::VisitorBase;

#define TYPE(CLASS, PARENT) DEFINE_VISIT(Type, CLASS, PARENT)
#include "swift/AST/TypeNodes.def"
};

#undef DEFINE_TRANSLATE_CHECKER
#undef DEFINE_VISIT

}  // namespace codeql
