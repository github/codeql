#pragma once

#include <swift/AST/ASTMangler.h>
#include <swift/AST/Types.h>

namespace codeql {
class SwiftMangler {
 public:
  std::string mangledName(const swift::Decl& decl);

  template <typename T>
  std::optional<std::string> mangleType(const T& type) {
    return std::nullopt;
  }

  std::optional<std::string> mangleType(const swift::ModuleType& type);

 private:
  swift::Mangle::ASTMangler mangler;
};

}  // namespace codeql
