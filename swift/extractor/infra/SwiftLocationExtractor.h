#pragma once

#include <swift/AST/ASTAllocated.h>
#include <swift/AST/AvailabilitySpec.h>
#include <swift/AST/SourceFile.h>
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

  TrapLabel<FileTag> emitFile(swift::SourceFile* file);
  TrapLabel<FileTag> emitFile(const std::filesystem::path& file);

  template <typename Locatable>
  void attachLocation(const swift::SourceManager& sourceManager,
                      Locatable locatable,
                      TrapLabel<LocatableTag> locatableLabel) {
    attachLocation(sourceManager, &locatable, locatableLabel);
  }

  // Emits a Location TRAP entry and attaches it to a `Locatable` trap label
  template <typename Locatable>
  void attachLocation(const swift::SourceManager& sourceManager,
                      Locatable* locatable,
                      TrapLabel<LocatableTag> locatableLabel) {
    attachLocation(sourceManager, locatable->getStartLoc(), locatable->getEndLoc(), locatableLabel);
  }

  // Emits a Location TRAP entry for a list of swift entities and attaches it to a `Locatable` trap
  // label
  template <typename Locatable>
  void attachLocation(const swift::SourceManager& sourceManager,
                      llvm::MutableArrayRef<Locatable>* locatables,
                      TrapLabel<LocatableTag> locatableLabel) {
    if (locatables->empty()) {
      return;
    }
    attachLocation(sourceManager, locatables->front().getStartLoc(), locatables->back().getEndLoc(),
                   locatableLabel);
  }

  void attachLocation(const swift::SourceManager& sourceManager,
                      swift::SourceLoc start,
                      swift::SourceLoc end,
                      TrapLabel<LocatableTag> locatableLabel);

  void attachLocation(const swift::SourceManager& sourceManager,
                      swift::SourceLoc loc,
                      TrapLabel<LocatableTag> locatableLabel);

  void attachLocation(const swift::SourceManager& sourceManager,
                      const swift::CapturedValue* capture,
                      TrapLabel<LocatableTag> locatableLabel);

  void attachLocation(const swift::SourceManager& sourceManager,
                      const swift::IfConfigClause* clause,
                      TrapLabel<LocatableTag> locatableLabel);

  void attachLocation(const swift::SourceManager& sourceManager,
                      swift::AvailabilitySpec* spec,
                      TrapLabel<LocatableTag> locatableLabel);

  void attachLocation(const swift::SourceManager& sourceManager,
                      swift::Token& token,
                      TrapLabel<LocatableTag> locatableLabel);

 private:
  TrapLabel<FileTag> fetchFileLabel(const std::filesystem::path& file);
  TrapDomain& trap;
  std::unordered_map<std::filesystem::path, TrapLabel<FileTag>> store;
};

}  // namespace codeql
