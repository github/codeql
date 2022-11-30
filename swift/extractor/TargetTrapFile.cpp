#include "swift/extractor/TargetTrapFile.h"
#include <iomanip>
namespace codeql {
std::optional<TargetFile> createTargetTrapFile(const SwiftExtractorConfiguration& configuration,
                                               SwiftExtractorState& state,
                                               const std::filesystem::path& target) {
  auto trap = target;
  trap += ".trap";
  auto ret = TargetFile::create(trap, configuration.trapDir, configuration.getTempTrapDir());
  state.trapFiles.push_back(trap.relative_path());
  if (ret) {
    *ret << "/* extractor-args:\n";
    for (const auto& opt : configuration.frontendOptions) {
      *ret << "  " << std::quoted(opt) << " \\\n";
    }
    *ret << "\n*/\n"
            "/* swift-frontend-args:\n";
    for (const auto& opt : configuration.patchedFrontendOptions) {
      *ret << "  " << std::quoted(opt) << " \\\n";
    }
    *ret << "\n*/\n";
  }
  return ret;
}
}  // namespace codeql
