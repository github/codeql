#include "swift/extractor/infra/file/Path.h"

#include <iostream>
#include <unistd.h>

#include "swift/extractor/infra/file/FsLogger.h"

using namespace std::string_view_literals;

namespace codeql {

using namespace fs_logger;

static bool shouldCanonicalize() {
  for (auto var : {"CODEQL_PRESERVE_SYMLINKS", "SEMMLE_PRESERVE_SYMLINKS"}) {
    if (auto preserve = getenv(var); preserve && preserve == "true"sv) {
      return false;
    }
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
    if (ec.value() == ENOENT) {
      // this is pretty normal, nothing to spam about
      LOG_DEBUG("resolving non-existing {}", path);
    } else {
      LOG_WARNING("cannot get {} path for {} ({})", canonicalize ? "canonical" : "absolute", path,
                  ec);
    }
    return path;
  }
  return ret;
}

}  // namespace codeql
