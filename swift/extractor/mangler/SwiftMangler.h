#pragma once

#include <swift/AST/ASTMangler.h>
#include <swift/AST/Types.h>

#include <random>
#include <variant>

#include "swift/extractor/trap/TrapLabel.h"

namespace codeql {

class SwiftDispatcher;

struct MangledName {
  using Part = std::variant<std::string, UntypedTrapLabel>;

  std::vector<Part> parts;
};

class SwiftMangler {
 public:
  explicit SwiftMangler(SwiftDispatcher& dispatcher) : dispatcher(dispatcher) {}
  std::string mangledName(const swift::Decl& decl);

  // default fallback for not yet mangled types. This should never be called in normal situations
  // will just spawn a random name
  // TODO: make it assert once we mangle all types
  static MangledName mangleType(const swift::TypeBase& type);

  MangledName mangleType(const swift::ModuleType& type);
  MangledName mangleType(const swift::TupleType& type);
  MangledName mangleType(const swift::BuiltinType& type);

 private:
  swift::Mangle::ASTMangler mangler;
  SwiftDispatcher& dispatcher;
};

std::ostream& operator<<(std::ostream& out, const MangledName& name);

}  // namespace codeql
