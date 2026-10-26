#include "swift/logging/SwiftLogging.h"

namespace codeql {
namespace fs_logger {
inline Logger& logger() {
  static Logger ret{"fs"};
  return ret;
}
}  // namespace fs_logger
}  // namespace codeql
