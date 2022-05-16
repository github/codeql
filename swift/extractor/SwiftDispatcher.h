#pragma once

#include "swift/extractor/trap/TrapArena.h"
#include "swift/extractor/trap/TrapLabelStore.h"
#include "swift/extractor/trap/generated/TrapClasses.h"
#include "swift/extractor/SwiftTagTraits.h"
#include <swift/AST/SourceFile.h>
#include <swift/Basic/SourceManager.h>
#include <llvm/Support/FileSystem.h>

namespace codeql {

namespace detail {

// The following `getKindName`s are used within "TBD" TRAP entries to visually mark an AST node as
// not properly emitted yet.
// TODO: To be replaced with QL counterpart
template <typename Parent, typename Kind>
inline std::string getKindName(Kind kind) {
  return Parent::getKindName(kind).str();
}

template <>
inline std::string getKindName<swift::TypeBase, swift::TypeKind>(swift::TypeKind kind) {
  switch (kind) {
#define TYPE(CLASS, PARENT)    \
  case swift::TypeKind::CLASS: \
    return #CLASS;
#include "swift/AST/TypeNodes.def"
    default:
      return "Unknown";
  }
}

template <>
std::string inline getKindName<swift::TypeRepr, swift::TypeReprKind>(swift::TypeReprKind kind) {
  switch (kind) {
#define TYPEREPR(CLASS, PARENT)    \
  case swift::TypeReprKind::CLASS: \
    return #CLASS;
#include "swift/AST/TypeReprNodes.def"
    default:
      return "Unknown";
  }
}

}  // namespace detail

// The main responsibilities of the SwiftDispatcher are as follows:
// * redirect specific AST node emission to a corresponding visitor (statements, expressions, etc.)
// * storing TRAP labels for emitted AST nodes (in the TrapLabelStore) to avoid re-emission
// Since SwiftDispatcher sees all the AST nodes, it also attaches a location to every 'locatable'
// node (AST nodes that are not types: declarations, statements, expressions, etc.).
class SwiftDispatcher {
 public:
  // sourceManager, arena, and trap are supposed to outlive the SwiftDispatcher
  SwiftDispatcher(const swift::SourceManager& sourceManager, TrapArena& arena, TrapOutput& trap)
      : sourceManager{sourceManager}, arena{arena}, trap{trap} {}

  // This is a helper method to emit TRAP entries for AST nodes that we don't fully support yet.
  template <typename Parent, typename Child>
  void TBD(Child* entity, const std::string& suffix) {
    using namespace std::string_literals;
    auto label = assignNewLabel(entity);
    auto kind = detail::getKindName<Parent>(static_cast<const Parent*>(entity)->getKind());
    auto name = "TBD ("s + kind + suffix + ")";
    if constexpr (std::is_same_v<Parent, swift::TypeBase>) {
      trap.emit(UnknownTypesTrap{label, name});
    } else {
      trap.emit(UnknownAstNodesTrap{label, name});
    }
  }

 private:
  // types to be supported by assignNewLabel/fetchLabel need to be listed here
  using Store = TrapLabelStore<swift::Decl,
                               swift::Stmt,
                               swift::Expr,
                               swift::Pattern,
                               swift::TypeRepr,
                               swift::TypeBase>;

  // This method gives a TRAP label for already emitted AST node.
  // If the AST node was not emitted yet, then the emission is dispatched to a corresponding
  // visitor (see `visit(T *)` methods below).
  template <typename E>
  TrapLabelOf<E> fetchLabel(E* e) {
    // this is required so we avoid any recursive loop: a `fetchLabel` during the visit of `e` might
    // end up calling `fetchLabel` on `e` itself, so we want the visit of `e` to call `fetchLabel`
    // only after having called `assignNewLabel` on `e`.
    assert(holds_alternative<std::monostate>(waitingForNewLabel) &&
           "fetchLabel called before assignNewLabel");
    if (auto l = store.get(e)) {
      return *l;
    }
    waitingForNewLabel = e;
    visit(e);
    if (auto l = store.get(e)) {
      if constexpr (!std::is_base_of_v<swift::TypeBase, E>) {
        attachLocation(e, *l);
      }
      return *l;
    }
    assert(!"assignNewLabel not called during visit");
    return {};
  }

  // Due to the lazy emission approach, we must assign a label to a corresponding AST node before
  // it actually gets emitted to handle recursive cases such as recursive calls, or recursive type
  // declarations
  template <typename E>
  TrapLabelOf<E> assignNewLabel(E* e) {
    assert(waitingForNewLabel == Store::Handle{e} && "assignNewLabel called on wrong entity");
    auto label = getLabel<TrapTagOf<E>>();
    trap.assignStar(label);
    store.insert(e, label);
    waitingForNewLabel = std::monostate{};
    return label;
  }

  template <typename Tag>
  TrapLabel<Tag> getLabel() {
    return arena.allocateLabel<Tag>();
  }

  template <typename Locatable>
  void attachLocation(Locatable locatable, TrapLabel<LocatableTag> locatableLabel) {
    attachLocation(&locatable, locatableLabel);
  }

  // Emits a Location TRAP entry and attaches it to an AST node
  template <typename Locatable>
  void attachLocation(Locatable* locatable, TrapLabel<LocatableTag> locatableLabel) {
    auto start = locatable->getStartLoc();
    auto end = locatable->getEndLoc();
    if (!start.isValid() || !end.isValid()) {
      // invalid locations seem to come from entities synthesized by the compiler
      return;
    }
    std::string filepath = getFilepath(start);
    auto fileLabel = arena.allocateLabel<FileTag>();
    trap.assignKey(fileLabel, filepath);
    // TODO: do not emit duplicate trap entries for Files
    trap.emit(FilesTrap{fileLabel, filepath});
    auto [startLine, startColumn] = sourceManager.getLineAndColumnInBuffer(start);
    auto [endLine, endColumn] = sourceManager.getLineAndColumnInBuffer(end);
    auto locLabel = arena.allocateLabel<LocationTag>();
    trap.assignKey(locLabel, '{', fileLabel, "}:", startLine, ':', startColumn, ':', endLine, ':',
                   endColumn);
    trap.emit(LocationsTrap{locLabel, fileLabel, startLine, startColumn, endLine, endColumn});
    trap.emit(LocatablesTrap{locatableLabel, locLabel});
  }

  std::string getFilepath(swift::SourceLoc loc) {
    // TODO: this needs more testing
    // TODO: check canonicaliztion of names on a case insensitive filesystems
    // TODO: make symlink resolution conditional on CODEQL_PRESERVE_SYMLINKS=true
    auto displayName = sourceManager.getDisplayNameForLoc(loc);
    llvm::SmallString<PATH_MAX> realPath;
    if (std::error_code ec = llvm::sys::fs::real_path(displayName, realPath)) {
      std::cerr << "Cannot get real path: '" << displayName.str() << "': " << ec.message() << "\n";
      return {};
    }
    return realPath.str().str();
  }

  // TODO: The following methods are supposed to redirect TRAP emission to correpsonding visitors,
  // which are to be introduced in follow-up PRs
  virtual void visit(swift::Decl* decl) = 0;
  virtual void visit(swift::Stmt* stmt) = 0;
  virtual void visit(swift::Expr* expr) = 0;
  virtual void visit(swift::Pattern* pattern) = 0;
  virtual void visit(swift::TypeRepr* type) = 0;
  virtual void visit(swift::TypeBase* type) = 0;

  const swift::SourceManager& sourceManager;
  TrapArena& arena;
  TrapOutput& trap;
  Store store;
  Store::Handle waitingForNewLabel{std::monostate{}};
};

}  // namespace codeql
