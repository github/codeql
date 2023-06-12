#pragma once

#include <swift/AST/ASTAllocated.h>
#include <swift/AST/AvailabilitySpec.h>
#include <swift/AST/Expr.h>
#include <swift/AST/SourceFile.h>
#include <swift/Basic/SourceManager.h>
#include <unordered_map>
#include <filesystem>

#include "swift/extractor/trap/generated/TrapEntries.h"

namespace codeql {

class TrapDomain;

class SwiftLocationExtractor {
  template <typename Locatable, typename = void>
  struct HasSpecializedImplementation : std::false_type {};

 public:
  explicit SwiftLocationExtractor(TrapDomain& trap) : trap(trap) {}

  TrapLabel<FileTag> emitFile(swift::SourceFile* file);
  TrapLabel<FileTag> emitFile(const std::filesystem::path& file);

  template <typename Locatable>
  void attachLocation(const swift::SourceManager& sourceManager,
                      const Locatable& locatable,
                      TrapLabel<LocatableTag> locatableLabel) {
    attachLocation(sourceManager, &locatable, locatableLabel);
  }

  // Emits a Location TRAP entry and attaches it to a `Locatable` trap label
  template <typename Locatable,
            std::enable_if_t<!HasSpecializedImplementation<Locatable>::value>* = nullptr>
  void attachLocation(const swift::SourceManager& sourceManager,
                      const Locatable* locatable,
                      TrapLabel<LocatableTag> locatableLabel) {
    attachLocationImpl(sourceManager, locatable->getStartLoc(), locatable->getEndLoc(),
                       locatableLabel);
  }

  template <typename Locatable,
            std::enable_if_t<HasSpecializedImplementation<Locatable>::value>* = nullptr>
  void attachLocation(const swift::SourceManager& sourceManager,
                      const Locatable* locatable,
                      TrapLabel<LocatableTag> locatableLabel) {
    attachLocationImpl(sourceManager, locatable, locatableLabel);
  }

 private:
  // Emits a Location TRAP entry for a list of swift entities and attaches it to a `Locatable` trap
  // label
  template <typename Locatable>
  void attachLocationImpl(const swift::SourceManager& sourceManager,
                          const llvm::MutableArrayRef<Locatable>* locatables,
                          TrapLabel<LocatableTag> locatableLabel) {
    if (locatables->empty()) {
      return;
    }
    attachLocationImpl(sourceManager, locatables->front().getStartLoc(),
                       locatables->back().getEndLoc(), locatableLabel);
  }

  void attachLocationImpl(const swift::SourceManager& sourceManager,
                          swift::SourceLoc start,
                          swift::SourceLoc end,
                          TrapLabel<LocatableTag> locatableLabel);

  void attachLocationImpl(const swift::SourceManager& sourceManager,
                          swift::SourceLoc loc,
                          TrapLabel<LocatableTag> locatableLabel);

  void attachLocationImpl(const swift::SourceManager& sourceManager,
                          const swift::SourceRange& range,
                          TrapLabel<LocatableTag> locatableLabel);

  void attachLocationImpl(const swift::SourceManager& sourceManager,
                          const swift::CapturedValue* capture,
                          TrapLabel<LocatableTag> locatableLabel);

  void attachLocationImpl(const swift::SourceManager& sourceManager,
                          const swift::IfConfigClause* clause,
                          TrapLabel<LocatableTag> locatableLabel);

  void attachLocationImpl(const swift::SourceManager& sourceManager,
                          const swift::AvailabilitySpec* spec,
                          TrapLabel<LocatableTag> locatableLabel);

  void attachLocationImpl(const swift::SourceManager& sourceManager,
                          const swift::Token* token,
                          TrapLabel<LocatableTag> locatableLabel);

  void attachLocationImpl(const swift::SourceManager& sourceManager,
                          const swift::DiagnosticInfo* token,
                          TrapLabel<LocatableTag> locatableLabel);

  void attachLocationImpl(const swift::SourceManager& sourceManager,
                          const swift::KeyPathExpr::Component* component,
                          TrapLabel<LocatableTag> locatableLabel);

 private:
  TrapLabel<FileTag> fetchFileLabel(const std::filesystem::path& file);
  TrapDomain& trap;
  std::unordered_map<std::filesystem::path, TrapLabel<FileTag>> store;
};

template <typename Locatable>
struct SwiftLocationExtractor::HasSpecializedImplementation<
    Locatable,
    decltype(std::declval<SwiftLocationExtractor>().attachLocationImpl(
        std::declval<const swift::SourceManager&>(),
        std::declval<const Locatable*>(),
        std::declval<TrapLabel<LocatableTag>>()))> : std::true_type {};

}  // namespace codeql
