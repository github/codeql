#pragma once

#include <concepts>

#include <swift/AST/ASTVisitor.h>
#include <swift/AST/TypeVisitor.h>

#include "swift/extractor/infra/SwiftDispatcher.h"

namespace codeql {

namespace detail {
class TranslatorBase {
 protected:
  SwiftDispatcher& dispatcher;
  Logger logger;

  // SwiftDispatcher should outlive this instance
  TranslatorBase(SwiftDispatcher& dispatcher, std::string_view name)
      : dispatcher{dispatcher}, logger{"translator/" + std::string(name)} {}
};

}  // namespace detail

enum class TranslatorPolicy {
  ignore,
  translate,
  translateParent,
  emitUnknown,
};

// we want to override the default swift visitor behaviour of chaining calls to immediate
// superclasses by default and instead provide our own TBD default (using the exact type).
// Moreover, if the implementation class has translate##CLASS##KIND (that uses generated C++
// classes), for the class of for a parent thereof, we want to use that. We detect that by using the
// type traits HasTranslate##CLASS##KIND defined above.
// A special case is for explicitly ignored classes marked with void, which we should never
// encounter.
#define DEFINE_VISIT(KIND, CLASS, PARENT)                                            \
 public:                                                                             \
  static constexpr TranslatorPolicy getPolicyFor##CLASS##KIND() {                    \
    if constexpr (std::same_as<TrapTagOf<swift::CLASS##KIND>, void>) {               \
      return TranslatorPolicy::ignore;                                               \
    } else if constexpr (requires(CrtpSubclass x, swift::CLASS##KIND e) {            \
                           x.translate##CLASS##KIND(e);                              \
                         }) {                                                        \
      return TranslatorPolicy::translate;                                            \
    } else if constexpr (requires(CrtpSubclass x, swift::CLASS##KIND e) {            \
                           x.translate##PARENT(e);                                   \
                         }) {                                                        \
      return TranslatorPolicy::translateParent;                                      \
    } else {                                                                         \
      return TranslatorPolicy::emitUnknown;                                          \
    }                                                                                \
  }                                                                                  \
                                                                                     \
 private:                                                                            \
  void visit##CLASS##KIND(swift::CLASS##KIND* e) {                                   \
    constexpr auto policy = getPolicyFor##CLASS##KIND();                             \
    if constexpr (policy == TranslatorPolicy::ignore) {                              \
      LOG_ERROR("Unexpected " #CLASS #KIND);                                         \
    } else if constexpr (policy == TranslatorPolicy::translate) {                    \
      dispatcher.emit(static_cast<CrtpSubclass*>(this)->translate##CLASS##KIND(*e)); \
    } else if constexpr (policy == TranslatorPolicy::translateParent) {              \
      dispatcher.emit(static_cast<CrtpSubclass*>(this)->translate##PARENT(*e));      \
    } else if constexpr (policy == TranslatorPolicy::emitUnknown) {                  \
      dispatcher.emitUnknown(e);                                                     \
    }                                                                                \
  }

// base class for our AST visitors, getting a SwiftDispatcher member and define_visit emission for
// unknown/TBD entities. Like `swift::ASTVisitor`, this uses CRTP (the Curiously Recurring Template
// Pattern)
template <typename CrtpSubclass>
class AstTranslatorBase : private swift::ASTVisitor<CrtpSubclass>,
                          protected detail::TranslatorBase {
 public:
  AstTranslatorBase(SwiftDispatcher& dispatcher) : TranslatorBase(dispatcher, CrtpSubclass::name) {}

  // swift does not provide const visitors. The following const_cast is safe, as we privately
  // route the visit to translateXXX functions only if they take const references to swift
  // entities (see HasTranslate##CLASS##KIND above)
  template <typename E>
  void translateAndEmit(const E& entity) {
    swift::ASTVisitor<CrtpSubclass>::visit(const_cast<E*>(&entity));
  }

  void translateAndEmit(const swift::CapturedValue& e) {
    dispatcher.emit(static_cast<CrtpSubclass*>(this)->translateCapturedValue(e));
  }

  void translateAndEmit(const swift::MacroRoleAttr& attr) {
    dispatcher.emit(static_cast<CrtpSubclass*>(this)->translateMacroRoleAttr(attr));
  }

 private:
  friend class swift::ASTVisitor<CrtpSubclass>;

#define DECL(CLASS, PARENT) DEFINE_VISIT(Decl, CLASS, PARENT)
#include "swift/AST/DeclNodes.def"

#define STMT(CLASS, PARENT) DEFINE_VISIT(Stmt, CLASS, PARENT)
#include "swift/AST/StmtNodes.def"

#define EXPR(CLASS, PARENT) DEFINE_VISIT(Expr, CLASS, PARENT)
#include "swift/AST/ExprNodes.def"

#define PATTERN(CLASS, PARENT) DEFINE_VISIT(Pattern, CLASS, PARENT)
#include "swift/AST/PatternNodes.def"
};

// base class for our type visitor, getting a SwiftDispatcher member and define_visit emission for
// unknown/TBD types. Like `swift::TypeVisitor`, this uses CRTP (the Curiously Recurring Template
// Pattern)
template <typename CrtpSubclass>
class TypeTranslatorBase : private swift::TypeVisitor<CrtpSubclass>,
                           protected detail::TranslatorBase {
 public:
  TypeTranslatorBase(SwiftDispatcher& dispatcher)
      : TranslatorBase(dispatcher, CrtpSubclass::name) {}

  // swift does not provide const visitors. The following const_cast is safe, as we privately
  // route the visit to translateXXX functions only if they take const references to swift
  // entities (see HasTranslate##CLASS##KIND above)
  void translateAndEmit(const swift::TypeBase& type) {
    swift::TypeVisitor<CrtpSubclass>::visit(const_cast<swift::TypeBase*>(&type));
  }

 private:
  friend class swift::TypeVisitor<CrtpSubclass>;

#define TYPE(CLASS, PARENT) DEFINE_VISIT(Type, CLASS, PARENT)
#include "swift/AST/TypeNodes.def"
};

#undef DEFINE_TRANSLATE_CHECKER
#undef DEFINE_VISIT

}  // namespace codeql
