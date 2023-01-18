#include "swift/extractor/infra/TargetDomains.h"
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
    case TrapType::linkage:
      return "linkage";
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

std::filesystem::path getTrapPath(const SwiftExtractorState& state,
                                  const std::filesystem::path& target,
                                  TrapType type) {
  return state.configuration.trapDir / getRelativeTrapPath(target, type);
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

std::optional<LinkDomain> createTargetLinkDomain(const SwiftExtractorState& state,
                                                 const std::filesystem::path& target) {
  if (target.empty()) {
    return std::nullopt;
  }
  auto file = getRelativeTrapPath(target, TrapType::linkage, ".link");
  auto ret =
      TargetFile::create(file, state.configuration.trapDir, state.configuration.getTempTrapDir());
  if (ret) {
    return LinkDomain{*std::move(ret)};
  }
  return std::nullopt;
}

std::optional<ObjectDomain> createTargetObjectDomain(const SwiftExtractorState& state,
                                                     const std::filesystem::path& target) {
  if (target.empty()) {
    return std::nullopt;
  }
  auto file = getRelativeTrapPath(target, TrapType::linkage, ".odep");
  auto ret =
      TargetFile::create(file, state.configuration.trapDir, state.configuration.getTempTrapDir());
  if (ret) {
    return ObjectDomain{*std::move(ret)};
  }
  return std::nullopt;
}

}  // namespace codeql
