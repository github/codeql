#pragma once

#include <swift/AST/ASTMangler.h>
#include <swift/AST/Types.h>
#include <swift/AST/ASTVisitor.h>
#include <swift/AST/TypeVisitor.h>

#include <variant>

#include "swift/extractor/trap/TrapLabel.h"
#include "swift/extractor/infra/SwiftMangledName.h"

namespace codeql {

class SwiftDispatcher;

class SwiftMangler : private swift::TypeVisitor<SwiftMangler, SwiftMangledName> {
 public:
  explicit SwiftMangler(SwiftDispatcher& dispatcher) : dispatcher(dispatcher) {}

  // TODO actual visit
  SwiftMangledName mangleDecl(const swift::Decl& decl);

  SwiftMangledName mangleType(const swift::TypeBase& type) {
    return visit(const_cast<swift::TypeBase*>(&type));
  }

 private:
  friend class swift::TypeVisitor<SwiftMangler, SwiftMangledName>;

  // default fallback for not yet mangled types. This should never be called in normal situations
  // will just spawn a random name
  // TODO: make it assert once we mangle all types
  static SwiftMangledName visitType(const swift::TypeBase* type) { return {}; }

  SwiftMangledName visitModuleType(const swift::ModuleType* type);

 private:
  swift::Mangle::ASTMangler mangler;
  SwiftDispatcher& dispatcher;
};

}  // namespace codeql
