#include "swift/extractor/infra/SwiftMangledName.h"
#include "absl/strings/str_cat.h"

#include <picosha2.h>

namespace codeql {

std::string SwiftMangledName::hash() const {
  auto ret = picosha2::hash256_hex_string(value);
  // half a hash is already enough for disambuiguation
  ret.resize(ret.size() / 2);
  return ret;
}

SwiftMangledName& SwiftMangledName::operator<<(UntypedTrapLabel label) & {
  absl::StrAppend(&value, "{", label.str(), "}");
  return *this;
}

SwiftMangledName& SwiftMangledName::operator<<(unsigned int i) & {
  absl::StrAppend(&value, i);
  return *this;
}

}  // namespace codeql
