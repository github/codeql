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

}  // namespace detail

// we want to override the default swift visitor behaviour of chaining calls to immediate
// superclasses by default and instead provide our own TBD default (using the exact type).
// Moreover, if the implementation class has translate##CLASS##KIND (that uses generated C++
// classes), we want to use that. We detect that by checking its return type. If it is different
// from void (which is what is returned by a private unimplemented member function here) it means
// we have implemented it in the visitor.
#define DEFAULT(KIND, CLASS, PARENT)                                                              \
 public:                                                                                          \
  void visit##CLASS##KIND(swift::CLASS##KIND* e) {                                                \
    using TranslateResult = std::invoke_result_t<decltype(&CrtpSubclass::translate##CLASS##KIND), \
                                                 CrtpSubclass, swift::CLASS##KIND&>;              \
    constexpr bool hasTranslateImplementation = !std::is_same_v<TranslateResult, void>;           \
    if constexpr (hasTranslateImplementation) {                                                   \
      dispatcher_.emit(static_cast<CrtpSubclass*>(this)->translate##CLASS##KIND(*e));             \
    } else {                                                                                      \
      dispatcher_.emitUnknown(e);                                                                 \
    }                                                                                             \
  }                                                                                               \
                                                                                                  \
 private:                                                                                         \
  void translate##CLASS##KIND(const swift::CLASS##KIND&);

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
