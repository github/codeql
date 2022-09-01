#pragma once

// This file implements the mapping needed by the API defined in the TrapTagTraits.h, so that
// TrapTagOf/TrapLabelOf provide the tags/labels for specific swift entity types.
#include <swift/AST/ASTVisitor.h>
#include "swift/extractor/trap/TrapTagTraits.h"
#include "swift/extractor/trap/generated/TrapTags.h"
#include "swift/extractor/infra/FilePath.h"

namespace codeql {

// codegen goes with QL acronym convention (Sil instead of SIL), we need to remap it to Swift's
// convention
using SILBlockStorageTypeTag = SilBlockStorageTypeTag;
using SILBoxTypeTag = SilBoxTypeTag;
using SILFunctionTypeTag = SilFunctionTypeTag;
using SILTokenTypeTag = SilTokenTypeTag;

#define MAP_TYPE_TO_TAG(TYPE, TAG)    \
  template <>                         \
  struct detail::ToTagFunctor<TYPE> { \
    using type = TAG;                 \
  }
#define MAP_TAG(TYPE) MAP_TYPE_TO_TAG(swift::TYPE, TYPE##Tag)
#define MAP_SUBTAG(TYPE, PARENT)                           \
  MAP_TAG(TYPE);                                           \
  static_assert(std::is_base_of_v<PARENT##Tag, TYPE##Tag>, \
                #PARENT "Tag must be a base of " #TYPE "Tag");

#define OVERRIDE_TAG(TYPE, TAG)               \
  template <>                                 \
  struct detail::ToTagOverride<swift::TYPE> { \
    using type = TAG;                         \
  };                                          \
  static_assert(std::is_base_of_v<TYPE##Tag, TAG>, "override is not a subtag");

MAP_TAG(Stmt);
MAP_TAG(StmtCondition);
MAP_TYPE_TO_TAG(swift::StmtConditionElement, ConditionElementTag);
MAP_TAG(CaseLabelItem);
#define ABSTRACT_STMT(CLASS, PARENT) MAP_SUBTAG(CLASS##Stmt, PARENT)
#define STMT(CLASS, PARENT) ABSTRACT_STMT(CLASS, PARENT)
#include <swift/AST/StmtNodes.def>

MAP_TAG(Expr);
MAP_TAG(Argument);
#define ABSTRACT_EXPR(CLASS, PARENT) MAP_SUBTAG(CLASS##Expr, PARENT)
#define EXPR(CLASS, PARENT) ABSTRACT_EXPR(CLASS, PARENT)
#include <swift/AST/ExprNodes.def>

MAP_TAG(Decl);
MAP_TAG(IfConfigClause);
#define ABSTRACT_DECL(CLASS, PARENT) MAP_SUBTAG(CLASS##Decl, PARENT)
#define DECL(CLASS, PARENT) ABSTRACT_DECL(CLASS, PARENT)
#include <swift/AST/DeclNodes.def>

MAP_TAG(Pattern);
#define ABSTRACT_PATTERN(CLASS, PARENT) MAP_SUBTAG(CLASS##Pattern, PARENT)
#define PATTERN(CLASS, PARENT) ABSTRACT_PATTERN(CLASS, PARENT)
#include <swift/AST/PatternNodes.def>

MAP_TAG(TypeRepr);

MAP_TYPE_TO_TAG(swift::TypeBase, TypeTag);
#define ABSTRACT_TYPE(CLASS, PARENT) MAP_SUBTAG(CLASS##Type, PARENT)
#define TYPE(CLASS, PARENT) ABSTRACT_TYPE(CLASS, PARENT)
#include <swift/AST/TypeNodes.def>

OVERRIDE_TAG(FuncDecl, ConcreteFuncDeclTag);
OVERRIDE_TAG(VarDecl, ConcreteVarDeclTag);

MAP_TYPE_TO_TAG(FilePath, DbFileTag);

#undef MAP_TAG
#undef MAP_SUBTAG
#undef MAP_TYPE_TO_TAG
#undef OVERRIDE_TAG

// All the other macros defined here are undefined by the .def files

}  // namespace codeql
