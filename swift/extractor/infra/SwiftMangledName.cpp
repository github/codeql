#include "swift/extractor/infra/SwiftMangledName.h"
#include "absl/strings/str_cat.h"

namespace codeql {

SwiftMangledName& SwiftMangledName::operator<<(UntypedTrapLabel label) & {
  absl::StrAppend(&value, "{", label.str(), "}");
  return *this;
}

SwiftMangledName& SwiftMangledName::operator<<(unsigned int i) & {
  absl::StrAppend(&value, i);
  return *this;
}

}  // namespace codeql
