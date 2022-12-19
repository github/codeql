#include "swift/extractor/TargetTrapDomain.h"
#include <iomanip>
namespace codeql {
std::optional<TrapDomain> createTargetTrapDomain(const SwiftExtractorConfiguration& configuration,
                                                 const std::filesystem::path& target) {
  auto trap = target;
  trap += ".trap";
  if (auto ret = TargetFile::create(trap, configuration.trapDir, configuration.getTempTrapDir())) {
    *ret << "/* extractor-args:\n";
    for (const auto& opt : configuration.frontendOptions) {
      *ret << "  " << std::quoted(opt) << " \\\n";
    }
    *ret << "\n*/\n";
    return TrapDomain{*std::move(ret)};
  }
  return std::nullopt;
}
}  // namespace codeql
