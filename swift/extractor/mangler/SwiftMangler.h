#pragma once

#include <swift/AST/ASTMangler.h>
#include <swift/AST/Types.h>

namespace codeql {

class SwiftDispatcher;

class SwiftMangler {
 public:
  explicit SwiftMangler(SwiftDispatcher& dispatcher) : dispatcher(dispatcher) {}
  std::string mangledName(const swift::Decl& decl);

  template <typename T>
  std::optional<std::string> mangleType(const T& type) {
    return std::nullopt;
  }

  std::optional<std::string> mangleType(const swift::ModuleType& type);
  std::optional<std::string> mangleType(const swift::TupleType& type);

#define TYPE(TYPE_ID, PARENT_TYPE)
#define BUILTIN_TYPE(TYPE_ID, PARENT_TYPE) \
  std::optional<std::string> mangleType(const swift::TYPE_ID##Type& type);
#include <swift/AST/TypeNodes.def>

 private:
  swift::Mangle::ASTMangler mangler;
  SwiftDispatcher& dispatcher;
};

}  // namespace codeql
