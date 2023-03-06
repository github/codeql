#pragma once

#include "swift/extractor/trap/TrapDomain.h"
#include "swift/extractor/trap/LinkDomain.h"
#include "swift/extractor/trap/ObjectDomain.h"
#include "swift/extractor/config/SwiftExtractorState.h"

namespace codeql {

enum class TrapType {
  source,
  module,
  invocation,
  linkage,
  lazy_declaration,
};

std::filesystem::path getTrapPath(const SwiftExtractorState& state,
                                  const std::filesystem::path& target,
                                  TrapType type);

std::optional<TrapDomain> createTargetTrapDomain(SwiftExtractorState& state,
                                                 const std::filesystem::path& target,
                                                 TrapType type);

std::optional<LinkDomain> createTargetLinkDomain(const SwiftExtractorState& state,
                                                 const std::filesystem::path& target);

std::optional<ObjectDomain> createTargetObjectDomain(const SwiftExtractorState& state,
                                                     const std::filesystem::path& target);

}  // namespace codeql
