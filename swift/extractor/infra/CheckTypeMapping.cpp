// this is a sanity check that the hierarchy in swift is mapped by the mapping in
// SwiftTypesToTagsMap.def to the hierarchy in schema.py
// We rely on that so that the LabelStore will preserve correct typing.
// For a class Derived: Base we could store the label for a Derived* pointer, and then fetch the
// label for the same pointer as Base*. If the mapping did not preserve inheritance, we would end up
// using a trap key of the DB type associated with Derived in a position expecting the incompatible
// DB type associated with Base.

#include "swift/extractor/infra/SwiftTagTraits.h"

using namespace codeql;

#define CHECK(KIND, TYPE, PARENT)                                                              \
  static_assert(std::is_same_v<TrapTagOf<swift::TYPE##KIND>, void> ||                          \
                    std::is_base_of_v<TrapTagOf<swift::PARENT>, TrapTagOf<swift::TYPE##KIND>>, \
                "Tag of " #PARENT " must be a base of the tag of " #TYPE #KIND);
#define CHECK_CONCRETE(KIND, TYPE, PARENT)                                                       \
  CHECK(KIND, TYPE, PARENT)                                                                      \
  static_assert(                                                                                 \
      std::is_same_v<TrapTagOf<swift::TYPE##KIND>, void> ||                                      \
          std::is_base_of_v<TrapTagOf<swift::TYPE##KIND>, ConcreteTrapTagOf<swift::TYPE##KIND>>, \
      "Tag of " #TYPE #KIND " must be a base of its concrete tag");

#define STMT(CLASS, PARENT) CHECK_CONCRETE(Stmt, CLASS, PARENT)
#define ABSTRACT_STMT(CLASS, PARENT) CHECK(Stmt, CLASS, PARENT)
#include <swift/AST/StmtNodes.def>

#define EXPR(CLASS, PARENT) CHECK_CONCRETE(Expr, CLASS, PARENT)
#define ABSTRACT_EXPR(CLASS, PARENT) CHECK(Expr, CLASS, PARENT)
#include <swift/AST/ExprNodes.def>

#define DECL(CLASS, PARENT) CHECK_CONCRETE(Decl, CLASS, PARENT)
#define ABSTRACT_DECL(CLASS, PARENT) CHECK(Decl, CLASS, PARENT)
#include <swift/AST/DeclNodes.def>

#define PATTERN(CLASS, PARENT) CHECK_CONCRETE(Pattern, CLASS, PARENT)
#define ABSTRACT_PATTERN(CLASS, PARENT) CHECK(Pattern, CLASS, PARENT)
#include <swift/AST/PatternNodes.def>

#define TYPE(CLASS, PARENT) CHECK_CONCRETE(Type, CLASS, PARENT)
#define ABSTRACT_TYPE(CLASS, PARENT) CHECK(Type, CLASS, PARENT)
#include <swift/AST/TypeNodes.def>
