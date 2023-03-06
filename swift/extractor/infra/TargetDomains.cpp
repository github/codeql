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
    case TrapType::lazy_declaration:
      return "lazy_decls";
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

namespace {
template <typename Domain>
std::optional<Domain> createTarget(const SwiftExtractorState& state,
                                   const std::filesystem::path& target,
                                   const char* extension) {
  if (target.empty()) {
    return std::nullopt;
  }
  auto file = getRelativeTrapPath(target, TrapType::linkage, extension);
  auto ret =
      TargetFile::create(file, state.configuration.trapDir, state.configuration.getTempTrapDir());
  if (ret) {
    return Domain{*std::move(ret)};
  }
  return std::nullopt;
}

}  // namespace

std::optional<LinkDomain> createTargetLinkDomain(const SwiftExtractorState& state,
                                                 const std::filesystem::path& target) {
  return createTarget<LinkDomain>(state, target, ".link");
}

std::optional<ObjectDomain> createTargetObjectDomain(const SwiftExtractorState& state,
                                                     const std::filesystem::path& target) {
  return createTarget<ObjectDomain>(state, target, ".odep");
}

}  // namespace codeql
