#pragma once

#include <vector>
#include <unordered_set>
#include <filesystem>

#include <swift/AST/Decl.h>

#include "swift/extractor/config/SwiftExtractorConfiguration.h"

namespace codeql {
struct SwiftExtractorState {
  const SwiftExtractorConfiguration configuration;

  // All the trap files related to this extraction. This may also include trap files generated in a
  // previous run but that this run requested as well. Paths are relative to `configuration.trapDir`
  std::vector<std::filesystem::path> traps;

  // All modules encountered during this extractor run, which therefore are dependencies of the
  // outcomes of this run
  std::unordered_set<const swift::ModuleDecl*> encounteredModules;

  std::vector<std::filesystem::path> sourceFiles;

  // The path for the modules outputted by the underlying frontend run, ignoring path redirection
  std::vector<std::filesystem::path> originalOutputModules;

  // All lazy named declarations that were already emitted
  std::unordered_set<const swift::Decl*> emittedDeclarations;

  // Lazy named declarations that were not yet emitted and will be emitted each one separately
  std::unordered_set<const swift::Decl*> pendingDeclarations;
};

}  // namespace codeql
