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

SwiftMangledName& SwiftMangledName::operator<<(UntypedTrapLabel label) & {
  assert(label && "using undefined label in mangled name");
  parts.emplace_back(label);
  return *this;
}

SwiftMangledName& SwiftMangledName::operator<<(unsigned int i) & {
  parts.emplace_back(i);
  return *this;
}

SwiftMangledName& SwiftMangledName::operator<<(SwiftMangledName&& other) & {
  parts.reserve(parts.size() + other.parts.size());
  for (auto& p : other.parts) {
    parts.emplace_back(std::move(p));
  }
  other.parts.clear();
  return *this;
}

SwiftMangledName& SwiftMangledName::operator<<(const SwiftMangledName& other) & {
  parts.reserve(parts.size() + other.parts.size());
  parts.insert(parts.end(), other.parts.begin(), other.parts.end());
  return *this;
}

}  // namespace codeql
