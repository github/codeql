#pragma once

#include <swift/AST/ASTAllocated.h>
#include <swift/AST/AvailabilitySpec.h>
#include <swift/AST/Expr.h>
#include <swift/AST/SourceFile.h>
#include <swift/Basic/SourceManager.h>
#include <unordered_map>
#include <filesystem>

#include "swift/extractor/trap/generated/TrapEntries.h"
#include "swift/extractor/infra/file/PathHash.h"

namespace codeql {

class TrapDomain;

namespace detail {
template <typename T>
concept HasStartAndEndLoc = requires(T e) {
  e.getStartLoc();
  e.getEndLoc();
};

template <typename T>
concept HasOneLoc = requires(T e) {
  e.getLoc();
}
&&(!HasStartAndEndLoc<T>);

template <typename T>
concept HasOneLocField = requires(T e) {
  e.Loc;
};

template <typename T>
concept HasSourceRangeOnly = requires(T e) {
  e.getSourceRange();
}
&&(!HasStartAndEndLoc<T>)&&(!HasOneLoc<T>);

swift::SourceRange getSourceRange(const HasStartAndEndLoc auto& locatable) {
  return {locatable.getStartLoc(), locatable.getEndLoc()};
}

swift::SourceRange getSourceRange(const HasOneLoc auto& locatable) {
  return {locatable.getLoc()};
}

swift::SourceRange getSourceRange(const HasOneLocField auto& locatable) {
  return {locatable.Loc};
}

swift::SourceRange getSourceRange(const HasSourceRangeOnly auto& locatable) {
  return locatable.getSourceRange();
}

swift::SourceRange getSourceRange(const swift::Token& token);

template <typename Locatable>
swift::SourceRange getSourceRange(const llvm::MutableArrayRef<Locatable>& locatables) {
  if (locatables.empty()) {
    return {};
  }
  auto startRange = getSourceRange(locatables.front());
  auto endRange = getSourceRange(locatables.back());
  return {startRange.Start, endRange.End};
}
}  // namespace detail

template <typename E>
concept IsLocatable = requires(E e) {
  detail::getSourceRange(e);
};

class SwiftLocationExtractor {
 public:
  explicit SwiftLocationExtractor(TrapDomain& trap) : trap(trap) {}

  TrapLabel<FileTag> emitFile(swift::SourceFile* file);
  TrapLabel<FileTag> emitFile(const std::filesystem::path& file);

  // Emits a Location TRAP entry and attaches it to a `Locatable` trap label
  void attachLocation(const swift::SourceManager& sourceManager,
                      const IsLocatable auto& locatable,
                      TrapLabel<LocatableTag> locatableLabel) {
    attachLocationImpl(sourceManager, detail::getSourceRange(locatable), locatableLabel);
  }

  void attachLocation(const swift::SourceManager& sourceManager,
                      const IsLocatable auto* locatable,
                      TrapLabel<LocatableTag> locatableLabel) {
    attachLocation(sourceManager, *locatable, locatableLabel);
  }

 private:
  void attachLocationImpl(const swift::SourceManager& sourceManager,
                          const swift::SourceRange& range,
                          TrapLabel<LocatableTag> locatableLabel);

 private:
  TrapLabel<FileTag> fetchFileLabel(const std::filesystem::path& file);
  TrapDomain& trap;
  std::unordered_map<std::filesystem::path, TrapLabel<FileTag>, codeql::PathHash> store;
};

}  // namespace codeql
