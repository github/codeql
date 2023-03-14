#pragma once

#include <swift/AST/ASTMangler.h>
#include <swift/AST/Types.h>
#include <swift/AST/ASTVisitor.h>
#include <swift/AST/TypeVisitor.h>

#include <variant>

#include "swift/extractor/trap/TrapLabel.h"
#include "swift/extractor/infra/SwiftMangledName.h"

#include <optional>

namespace codeql {

class SwiftDispatcher;

class SwiftMangler : private swift::TypeVisitor<SwiftMangler, SwiftMangledName>,
                     private swift::DeclVisitor<SwiftMangler, SwiftMangledName> {
 public:
  explicit SwiftMangler(SwiftDispatcher& dispatcher) : dispatcher(dispatcher) {}

  static SwiftMangledName mangleModuleName(std::string_view name);

  // TODO actual visit
  SwiftMangledName mangleDecl(const swift::Decl& decl) {
    return swift::DeclVisitor<SwiftMangler, SwiftMangledName>::visit(
        const_cast<swift::Decl*>(&decl));
  }

  SwiftMangledName mangleType(const swift::TypeBase& type) {
    return swift::TypeVisitor<SwiftMangler, SwiftMangledName>::visit(
        const_cast<swift::TypeBase*>(&type));
  }

 private:
  friend class swift::TypeVisitor<SwiftMangler, SwiftMangledName>;
  friend class swift::ASTVisitor<SwiftMangler, void, void, SwiftMangledName>;

  // assign no name by default
  static SwiftMangledName visitDecl(const swift::Decl* decl) { return {}; }

  // current default, falling back to internal mangling
  SwiftMangledName visitValueDecl(const swift::ValueDecl* decl);

  SwiftMangledName visitModuleDecl(const swift::ModuleDecl* decl);
  SwiftMangledName visitGenericTypeDecl(const swift::GenericTypeDecl* decl);

  // default fallback for not yet mangled types. This should never be called in normal situations
  // will just spawn a random name
  // TODO: make it assert once we mangle all types
  SwiftMangledName visitType(const swift::TypeBase* type);

  SwiftMangledName visitModuleType(const swift::ModuleType* type);
  SwiftMangledName visitTupleType(const swift::TupleType* type);
  SwiftMangledName visitBuiltinType(const swift::BuiltinType* type);
  SwiftMangledName visitAnyGenericType(const swift::AnyGenericType* type);

  // shouldn't be required, but they forgot to link `NominalType` to its direct superclass
  // in swift/AST/TypeNodes.def, so we need to chain the call manually
  SwiftMangledName visitNominalType(const swift::NominalType* type) {
    return visitAnyGenericType(type);
  }

  SwiftMangledName visitBoundGenericType(const swift::BoundGenericType* type);

 private:
  swift::Mangle::ASTMangler mangler;
  SwiftDispatcher& dispatcher;
};

}  // namespace codeql
