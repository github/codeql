#include "swift/extractor/TargetTrapDomain.h"
#include <iomanip>
namespace codeql {
static const char* typeToStr(TrapType type) {
  switch (type) {
    case TrapType::source:
      return "sources";
    case TrapType::module:
      return "modules";
    case TrapType::invocation:
      return "invocations";
    default:
      return "";
  }
}

static std::filesystem::path getRelativeTrapPath(const std::filesystem::path& target,
                                                 TrapType type,
                                                 const char* extension = ".trap") {
  auto trap = typeToStr(type) / target.relative_path();
  trap += extension;
  return trap;
}

std::optional<TrapDomain> createTargetTrapDomain(SwiftExtractorState& state,
                                                 const std::filesystem::path& target,
                                                 TrapType type) {
  if (target.empty()) {
    return std::nullopt;
  }
  auto trap = getRelativeTrapPath(target, type);
  auto ret =
      TargetFile::create(trap, state.configuration.trapDir, state.configuration.getTempTrapDir());
  state.traps.push_back(std::move(trap));
  if (ret) {
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
