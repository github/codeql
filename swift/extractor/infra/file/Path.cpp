#include "swift/extractor/infra/file/Path.h"
#include <iostream>
#include <unistd.h>

namespace codeql {

static bool shouldCanonicalize() {
  auto preserve = getenv("CODEQL_PRESERVE_SYMLINKS");
  if (preserve && std::string(preserve) == "true") {
    return false;
  }
  preserve = getenv("SEMMLE_PRESERVE_SYMLINKS");
  if (preserve && std::string(preserve) == "true") {
    return false;
  }
  return true;
}

std::filesystem::path resolvePath(const std::filesystem::path& path) {
  std::error_code ec;
  std::filesystem::path ret = {};
  static const auto canonicalize = shouldCanonicalize();
  if (canonicalize) {
    ret = std::filesystem::weakly_canonical(path, ec);
  } else {
    ret = std::filesystem::absolute(path, ec);
  }
  if (ec) {
    std::cerr << "Cannot get " << (canonicalize ? "canonical" : "absolute") << " path: " << path
              << ": " << ec.message() << "\n";
    return path;
  }
  return ret;
}

}  // namespace codeql
