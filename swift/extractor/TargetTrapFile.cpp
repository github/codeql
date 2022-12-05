#include "swift/extractor/TargetTrapFile.h"
#include <iomanip>
namespace codeql {
std::optional<TargetFile> createTargetTrapFile(const SwiftExtractorConfiguration& configuration,
                                               const std::filesystem::path& target) {
  auto trap = target;
  trap += ".trap";
  auto ret = TargetFile::create(trap, configuration.trapDir, configuration.getTempTrapDir());
  if (ret) {
    *ret << "/* extractor-args:\n";
    for (const auto& opt : configuration.frontendOptions) {
      *ret << "  " << std::quoted(opt) << " \\\n";
    }
    *ret << "\n*/\n";
  }
  return ret;
}
}  // namespace codeql
