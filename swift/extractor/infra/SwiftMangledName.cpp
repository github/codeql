#include "swift/extractor/infra/SwiftMangledName.h"
#include "absl/strings/str_cat.h"

namespace codeql {

namespace {
void appendPart(std::string& out, const std::string& prefix) {
  out += prefix;
}

void appendPart(std::string& out, UntypedTrapLabel label) {
  absl::StrAppend(&out, "{", label.str(), "}");
}

void appendPart(std::string& out, unsigned index) {
  absl::StrAppend(&out, index);
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
