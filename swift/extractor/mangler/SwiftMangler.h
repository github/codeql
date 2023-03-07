#pragma once

#include <vector>
#include <unordered_set>
#include <filesystem>

#include <swift/AST/ASTMangler.h>

namespace codeql {
class SwiftMangler {
 public:
  std::string mangledName(const swift::Decl& decl);

 private:
  swift::Mangle::ASTMangler mangler;
};

}  // namespace codeql
