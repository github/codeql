#pragma once

#include <vector>
#include <filesystem>
#include <unordered_set>

#include <swift/AST/Decl.h>

namespace codeql {
struct SwiftExtractorState {
  // The relative paths to TRAP files requested by this run. This includes TRAP files that were
  // skipped due to them being already filled by other runs
  std::vector<std::filesystem::path> trapFiles;

  // The Swift modules encountered during this run
  std::unordered_set<const swift::ModuleDecl*> encounteredModules;
};

}  // namespace codeql
