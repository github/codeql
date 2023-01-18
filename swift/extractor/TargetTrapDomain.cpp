#include "swift/extractor/TargetTrapDomain.h"
#include <iomanip>
namespace codeql {
std::optional<TrapDomain> createTargetTrapDomain(SwiftExtractorState& state,
                                                 const std::filesystem::path& target) {
  auto trap = target;
  trap += ".trap";
  state.traps.push_back(trap.relative_path());
  if (auto ret = TargetFile::create(trap, state.configuration.trapDir,
                                    state.configuration.getTempTrapDir())) {
    *ret << "/* extractor-args:\n";
    for (const auto& opt : state.configuration.frontendOptions) {
      *ret << "  " << std::quoted(opt) << " \\\n";
    }
    *ret << "\n*/\n";
    return TrapDomain{*std::move(ret)};
  }
  return std::nullopt;
}
}  // namespace codeql
