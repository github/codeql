#include "swift/extractor/infra/SwiftMangledName.h"

namespace codeql {

namespace {
void appendPart(std::string& out, const std::string& prefix) {
  out += prefix;
}

void appendPart(std::string& out, UntypedTrapLabel label) {
  out += '{';
  out += label.str();
  out += '}';
}

void appendPart(std::string& out, unsigned index) {
  out += std::to_string(index);
}

}  // namespace

std::string SwiftMangledName::str() const {
  std::string out;
  for (const auto& part : parts) {
    std::visit([&](const auto& contents) { appendPart(out, contents); }, part);
  }
  return out;
}

}  // namespace codeql
