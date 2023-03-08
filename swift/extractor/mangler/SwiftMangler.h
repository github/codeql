#pragma once

#include <swift/AST/ASTMangler.h>
#include <swift/AST/Types.h>

#include <random>

namespace codeql {

class SwiftDispatcher;

class SwiftMangler {
 public:
  explicit SwiftMangler(SwiftDispatcher& dispatcher) : dispatcher(dispatcher) {}
  std::string mangledName(const swift::Decl& decl);

  // default fallback for unmangled types. This should never be called in normal situations
  // TODO: make it assert once we mangle all types
  static std::string mangleType(const swift::TypeBase& type);

  std::string mangleType(const swift::ModuleType& type);
  std::string mangleType(const swift::TupleType& type);
  std::string mangleType(const swift::BuiltinType& type);

 private:
  swift::Mangle::ASTMangler mangler;
  SwiftDispatcher& dispatcher;
};

}  // namespace codeql
