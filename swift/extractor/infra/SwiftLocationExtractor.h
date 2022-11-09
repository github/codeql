#pragma once

#include <swift/Basic/SourceManager.h>
#include <unordered_map>
#include <filesystem>

#include "swift/extractor/trap/generated/TrapEntries.h"
#include "swift/extractor/infra/file/PathHash.h"

namespace codeql {

class TrapDomain;

class SwiftLocationExtractor {
 public:
  explicit SwiftLocationExtractor(TrapDomain& trap) : trap(trap) {}

  void attachLocation(const swift::SourceManager& sourceManager,
                      swift::SourceLoc start,
                      swift::SourceLoc end,
                      TrapLabel<LocatableTag> locatableLabel);

  void emitFile(llvm::StringRef path);

 private:
  TrapLabel<FileTag> fetchFileLabel(const std::filesystem::path& file);
  TrapDomain& trap;
  std::unordered_map<std::filesystem::path, TrapLabel<FileTag>> store;
};

}  // namespace codeql
