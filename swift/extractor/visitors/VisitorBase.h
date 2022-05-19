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
};

}  // namespace detail

// we want to override the default swift visitor behaviour of chaining calls to immediate
// superclasses by default and instead provide our own TBD default (using the exact type)
// if we the implementation class has translate##CLASS##KIND (that uses generated C++ classes), we
// want to use that. We detect that by comparing the member function pointer to the one for a
// private undefined member function of the same name and signature in {Ast,Type}VisitorBase, which
// will be shadowed (and thus different) in case the implementation class has it.
#define DEFAULT(KIND, CLASS, PARENT)                                              \
 public:                                                                          \
  void visit##CLASS##KIND(swift::CLASS##KIND* e) {                                \
    constexpr bool hasTranslateImplementation =                                   \
        (&Self::translate##CLASS##KIND != &CrtpSubclass::translate##CLASS##KIND); \
    if constexpr (hasTranslateImplementation) {                                   \
      TrapClassOf<swift::CLASS##KIND> entry{};                                    \
      static_cast<CrtpSubclass*>(this)->translate##CLASS##KIND(e, &entry);        \
      dispatcher_.emit(entry);                                                    \
    } else {                                                                      \
      dispatcher_.emitUnknown(e);                                                 \
    }                                                                             \
  }                                                                               \
                                                                                  \
 private:                                                                         \
  void translate##CLASS##KIND(swift::CLASS##KIND*, TrapClassOf<swift::CLASS##KIND>*);

// base class for our AST visitors, getting a SwiftDispatcher member and default emission for
// unknown/TBD entities. Like `swift::ASTVisitor`, this uses CRTP (the Curiously Recurring Template
// Pattern)
template <typename CrtpSubclass>
class AstVisitorBase : public swift::ASTVisitor<CrtpSubclass>, protected detail::VisitorBase {
  using Self = AstVisitorBase;

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
  using Self = TypeVisitorBase;

 public:
  using VisitorBase::VisitorBase;

#define TYPE(CLASS, PARENT) DEFAULT(Type, CLASS, PARENT)
#include "swift/AST/TypeNodes.def"
};

#undef DEFAULT

}  // namespace codeql
