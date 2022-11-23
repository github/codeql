#pragma once

// This file implements the mapping needed by the API defined in the TrapTagTraits.h, so that
// TrapTagOf/TrapLabelOf provide the tags/labels for specific swift entity types.
#include <filesystem>
#include <swift/AST/ASTVisitor.h>
#include "swift/extractor/trap/TrapTagTraits.h"
#include "swift/extractor/trap/generated/TrapTags.h"

namespace codeql {

// OverloadSetRefExpr is collapsed with its only derived class OverloadedDeclRefExpr
using OverloadSetRefExprTag = OverloadedDeclRefExprTag;

// We don't really expect to see the following in extraction. Mapping these tags to void effectively
// ignores all elements of that class (with a message).

// only generated for code editing
using CodeCompletionExprTag = void;
using EditorPlaceholderExprTag = void;
// not present after the Sema phase
using ArrowExprTag = void;
// experimental variadic generics, implemented only in the frontend for now, thus not compilable
using PackExprTag = void;
using PackTypeTag = void;
using ReifyPackExprTag = void;
using PackExpansionTypeTag = void;
using SequenceArchetypeTypeTag = void;
// Placeholder types appear in ambiguous types but are anyway transformed to UnresolvedType
using PlaceholderTypeTag = void;
// SIL types that cannot really appear in the frontend run
using SILBlockStorageTypeTag = void;
using SILBoxTypeTag = void;
using SILFunctionTypeTag = void;
using SILTokenTypeTag = void;
// This is created during type checking and is only used for constraint checking
using TypeVariableTypeTag = void;

using ABISafeConversionExprTag = AbiSafeConversionExprTag;

#define MAP_TYPE_TO_TAG(TYPE, TAG)    \
  template <>                         \
  struct detail::ToTagFunctor<TYPE> { \
    using type = TAG;                 \
  }
#define MAP_TAG(TYPE) MAP_TYPE_TO_TAG(swift::TYPE, TYPE##Tag)
#define MAP_SUBTAG(TYPE, PARENT)                                                              \
  MAP_TAG(TYPE);                                                                              \
  static_assert(std::is_same_v<TYPE##Tag, void> || std::is_base_of_v<PARENT##Tag, TYPE##Tag>, \
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

MAP_TYPE_TO_TAG(std::filesystem::path, DbFileTag);

#undef MAP_TAG
#undef MAP_SUBTAG
#undef MAP_TYPE_TO_TAG
#undef OVERRIDE_TAG

// All the other macros defined here are undefined by the .def files

}  // namespace codeql
