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
concept HasSourceRange = requires(T e) { e.getSourceRange(); };

template <typename T>
concept HasStartAndEndLoc = requires(T e) {
  e.getStartLoc();
  e.getEndLoc();
} && !(HasSourceRange<T>);

template <typename T>
concept HasLAndRParenLoc = requires(T e) {
  e.getLParenLoc();
  e.getRParenLoc();
} && !(HasSourceRange<T>)&&!(HasStartAndEndLoc<T>);

template <typename T>
concept HasOneLoc = requires(T e) { e.getLoc(); } && !(HasSourceRange<T>)&&(!HasStartAndEndLoc<T>);

template <typename T>
concept HasOneLocField = requires(T e) { e.Loc; };

swift::SourceRange getSourceRange(const HasSourceRange auto& locatable) {
  return locatable.getSourceRange();
}

swift::SourceRange getSourceRange(const HasStartAndEndLoc auto& locatable) {
  if (locatable.getStartLoc() && locatable.getEndLoc()) {
    return {locatable.getStartLoc(), locatable.getEndLoc()};
  }
  return {locatable.getStartLoc()};
}

swift::SourceRange getSourceRange(const HasLAndRParenLoc auto& locatable) {
  if (locatable.getLParenLoc() && locatable.getRParenLoc()) {
    return {locatable.getLParenLoc(), locatable.getRParenLoc()};
  }
  return {locatable.getLParenLoc()};
}

swift::SourceRange getSourceRange(const HasOneLoc auto& locatable) {
  return {locatable.getLoc()};
}

swift::SourceRange getSourceRange(const HasOneLocField auto& locatable) {
  return {locatable.Loc};
}

swift::SourceRange getSourceRange(const swift::Token& token);

template <typename Locatable>
swift::SourceRange getSourceRange(const llvm::MutableArrayRef<Locatable>& locatables) {
  if (locatables.empty()) {
    return {};
  }
  auto startRange = getSourceRange(locatables.front());
  auto endRange = getSourceRange(locatables.back());
  if (startRange.Start && endRange.End) {
    return {startRange.Start, endRange.End};
  }
  return {startRange.Start};
}
}  // namespace detail

template <typename E>
concept IsLocatable = requires(E e) { detail::getSourceRange(e); };

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
