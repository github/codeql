#pragma once

#include "swift/extractor/trap/TrapArena.h"
#include "swift/extractor/trap/TrapLabelStore.h"
#include "swift/extractor/trap/generated/TrapClasses.h"
#include "swift/extractor/SwiftTagTraits.h"
#include <swift/AST/SourceFile.h>
#include <swift/Basic/SourceManager.h>
#include <llvm/Support/FileSystem.h>

namespace codeql {

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

  template <typename Entry>
  void emit(const Entry& entry) {
    trap.emit(entry);
  }

  // This is a helper method to emit TRAP entries for AST nodes that we don't fully support yet.
  template <typename E>
  void emitUnknown(E* entity) {
    auto label = assignNewLabel(entity);
    using Trap = BindingTrapOf<E>;
    static_assert(sizeof(Trap) == sizeof(label),
                  "Binding traps of unknown entities must only have the `id` field (the class "
                  "should be empty in schema.yml)");
    emit(Trap{label});
    emit(ElementIsUnknownTrap{label});
  }

  // This method gives a TRAP label for already emitted AST node.
  // If the AST node was not emitted yet, then the emission is dispatched to a corresponding
  // visitor (see `visit(T *)` methods below).
  template <typename E>
  TrapLabelOf<E> fetchLabel(E* e) {
    // this is required so we avoid any recursive loop: a `fetchLabel` during the visit of `e` might
    // end up calling `fetchLabel` on `e` itself, so we want the visit of `e` to call `fetchLabel`
    // only after having called `assignNewLabel` on `e`.
    assert(std::holds_alternative<std::monostate>(waitingForNewLabel) &&
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

  // convenience `fetchLabel` overload for `swift::Type` (which is just a wrapper for
  // `swift::TypeBase*`)
  TrapLabel<TypeTag> fetchLabel(swift::Type t) { return fetchLabel(t.getPointer()); }

  TrapLabel<AstNodeTag> fetchLabel(swift::ASTNode node) {
    return fetchLabelFromUnion<AstNodeTag>(node);
  }

  // Due to the lazy emission approach, we must assign a label to a corresponding AST node before
  // it actually gets emitted to handle recursive cases such as recursive calls, or recursive type
  // declarations
  template <typename E>
  TrapLabelOf<E> assignNewLabel(E* e) {
    assert(waitingForNewLabel == Store::Handle{e} && "assignNewLabel called on wrong entity");
    auto label = createLabel<TrapTagOf<E>>();
    store.insert(e, label);
    waitingForNewLabel = std::monostate{};
    return label;
  }

  template <typename Tag>
  TrapLabel<Tag> createLabel() {
    auto ret = arena.allocateLabel<Tag>();
    trap.assignStar(ret);
    return ret;
  }

  template <typename Tag, typename... Args>
  TrapLabel<Tag> createLabel(Args&&... args) {
    auto ret = arena.allocateLabel<Tag>();
    trap.assignKey(ret, std::forward<Args>(args)...);
    return ret;
  }

  template <typename Locatable>
  void attachLocation(Locatable locatable, TrapLabel<LocatableTag> locatableLabel) {
    attachLocation(&locatable, locatableLabel);
  }

  // Emits a Location TRAP entry and attaches it to a `Locatable` trap label
  template <typename Locatable>
  void attachLocation(Locatable* locatable, TrapLabel<LocatableTag> locatableLabel) {
    attachLocation(locatable->getStartLoc(), locatable->getEndLoc(), locatableLabel);
  }

  // Emits a Location TRAP entry for a list of swift entities and attaches it to a `Locatable` trap
  // label
  template <typename Locatable>
  void attachLocation(llvm::MutableArrayRef<Locatable>* locatables,
                      TrapLabel<LocatableTag> locatableLabel) {
    if (locatables->empty()) {
      return;
    }
    attachLocation(locatables->front().getStartLoc(), locatables->back().getEndLoc(),
                   locatableLabel);
  }

 private:
  // types to be supported by assignNewLabel/fetchLabel need to be listed here
  using Store = TrapLabelStore<swift::Decl,
                               swift::Stmt,
                               swift::StmtCondition,
                               swift::CaseLabelItem,
                               swift::Expr,
                               swift::Pattern,
                               swift::TypeRepr,
                               swift::TypeBase>;

  void attachLocation(swift::SourceLoc start,
                      swift::SourceLoc end,
                      TrapLabel<LocatableTag> locatableLabel) {
    if (!start.isValid() || !end.isValid()) {
      // invalid locations seem to come from entities synthesized by the compiler
      return;
    }
    std::string filepath = getFilepath(start);
    auto fileLabel = createLabel<FileTag>(filepath);
    // TODO: do not emit duplicate trap entries for Files
    trap.emit(FilesTrap{fileLabel, filepath});
    auto [startLine, startColumn] = sourceManager.getLineAndColumnInBuffer(start);
    auto [endLine, endColumn] = sourceManager.getLineAndColumnInBuffer(end);
    auto locLabel = createLabel<LocationTag>('{', fileLabel, "}:", startLine, ':', startColumn, ':',
                                             endLine, ':', endColumn);
    trap.emit(LocationsTrap{locLabel, fileLabel, startLine, startColumn, endLine, endColumn});
    trap.emit(LocatablesTrap{locatableLabel, locLabel});
  }

  template <typename Tag, typename... Ts>
  TrapLabel<Tag> fetchLabelFromUnion(const llvm::PointerUnion<Ts...> u) {
    TrapLabel<Tag> ret{};
    // with logical op short-circuiting, this will stop trying on the first successful fetch
    // don't feel tempted to replace the variable with the expression inside the `assert`, or
    // building with `NDEBUG` will not trigger the fetching
    bool unionCaseFound = (... || fetchLabelFromUnionCase<Tag, Ts>(u, ret));
    assert(unionCaseFound && "llvm::PointerUnion not set to a known case");
    return ret;
  }

  template <typename Tag, typename T, typename... Ts>
  bool fetchLabelFromUnionCase(const llvm::PointerUnion<Ts...> u, TrapLabel<Tag>& output) {
    if (auto e = u.template dyn_cast<T>()) {
      output = fetchLabel(e);
      return true;
    }
    return false;
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
  virtual void visit(swift::StmtCondition* cond) = 0;
  virtual void visit(swift::CaseLabelItem* item) = 0;
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
