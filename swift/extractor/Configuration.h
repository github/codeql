#ifndef SWIFT_EXTRACTOR_CONFIGURATION_H_
#define SWIFT_EXTRACTOR_CONFIGURATION_H_

#include <string>
#include <vector>

namespace codeql {
struct Configuration {
  std::string trapDir;
  std::string sourceArchiveDir;
  std::vector<const char*> frontendOptions;
};
}  // namespace codeql

#endif  // SWIFT_EXTRACTOR_CONFIGURATION_H_
