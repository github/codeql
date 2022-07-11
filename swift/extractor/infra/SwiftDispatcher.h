#pragma once

#include <swift/AST/SourceFile.h>
#include <swift/Basic/SourceManager.h>
#include <llvm/Support/FileSystem.h>

#include "swift/extractor/trap/TrapArena.h"
#include "swift/extractor/trap/TrapLabelStore.h"
#include "swift/extractor/trap/TrapOutput.h"
#include "swift/extractor/infra/SwiftTagTraits.h"
#include "swift/extractor/trap/generated/TrapClasses.h"

namespace codeql {

// The main responsibilities of the SwiftDispatcher are as follows:
// * redirect specific AST node emission to a corresponding visitor (statements, expressions, etc.)
// * storing TRAP labels for emitted AST nodes (in the TrapLabelStore) to avoid re-emission
// Since SwiftDispatcher sees all the AST nodes, it also attaches a location to every 'locatable'
// node (AST nodes that are not types: declarations, statements, expressions, etc.).
class SwiftDispatcher {
 public:
  // all references and pointers passed as parameters to this constructor are supposed to outlive
  // the SwiftDispatcher
  SwiftDispatcher(const swift::SourceManager& sourceManager,
                  TrapArena& arena,
                  TrapOutput& trap,
                  swift::ModuleDecl& currentModule,
                  swift::SourceFile* currentPrimarySourceFile = nullptr)
      : sourceManager{sourceManager},
        arena{arena},
        trap{trap},
        currentModule{currentModule},
        currentPrimarySourceFile{currentPrimarySourceFile} {}

  template <typename Entry>
  void emit(const Entry& entry) {
    trap.emit(entry);
  }

  template <typename Entry>
  void emit(const std::optional<Entry>& entry) {
    if (entry) {
      emit(*entry);
    }
  }

  template <typename... Cases>
  void emit(const std::variant<Cases...>& entry) {
    std::visit([this](const auto& e) { this->emit(e); }, entry);
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
    assert(e && "trying to fetch a label on nullptr, maybe fetchOptionalLabel is to be used?");
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
      if constexpr (std::is_base_of_v<LocatableTag, TrapTagOf<E>>) {
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

  TrapLabel<IfConfigClauseTag> fetchLabel(const swift::IfConfigClause& clause) {
    return fetchLabel(&clause);
  }

  // Due to the lazy emission approach, we must assign a label to a corresponding AST node before
  // it actually gets emitted to handle recursive cases such as recursive calls, or recursive type
  // declarations
  template <typename E, typename... Args>
  TrapLabelOf<E> assignNewLabel(E* e, Args&&... args) {
    assert(waitingForNewLabel == Store::Handle{e} && "assignNewLabel called on wrong entity");
    auto label = createLabel<TrapTagOf<E>>(std::forward<Args>(args)...);
    store.insert(e, label);
    waitingForNewLabel = std::monostate{};
    return label;
  }

  template <typename E, typename... Args, std::enable_if_t<!std::is_pointer_v<E>>* = nullptr>
  TrapLabelOf<E> assignNewLabel(const E& e, Args&&... args) {
    return assignNewLabel(&e, std::forward<Args>(args)...);
  }

  // convenience methods for structured C++ creation
  template <typename E, typename... Args, std::enable_if_t<!std::is_pointer_v<E>>* = nullptr>
  auto createEntry(const E& e, Args&&... args) {
    return TrapClassOf<E>{assignNewLabel(&e, std::forward<Args>(args)...)};
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

  void attachLocation(const swift::IfConfigClause* clause, TrapLabel<LocatableTag> locatableLabel) {
    attachLocation(clause->Loc, clause->Loc, locatableLabel);
  }

  // Emits a Location TRAP entry and attaches it to a `Locatable` trap label for a given `SourceLoc`
  void attachLocation(swift::SourceLoc loc, TrapLabel<LocatableTag> locatableLabel) {
    attachLocation(loc, loc, locatableLabel);
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

  // return `std::optional(fetchLabel(arg))` if arg converts to true, otherwise std::nullopt
  // universal reference `Arg&&` is used to catch both temporary and non-const references, not
  // for perfect forwarding
  template <typename Arg>
  auto fetchOptionalLabel(Arg&& arg) -> std::optional<decltype(fetchLabel(arg))> {
    if (arg) {
      return fetchLabel(arg);
    }
    return std::nullopt;
  }

  // map `fetchLabel` on the iterable `arg`, returning a vector of all labels
  // universal reference `Arg&&` is used to catch both temporary and non-const references, not
  // for perfect forwarding
  template <typename Iterable>
  auto fetchRepeatedLabels(Iterable&& arg) {
    std::vector<decltype(fetchLabel(*arg.begin()))> ret;
    ret.reserve(arg.size());
    for (auto&& e : arg) {
      ret.push_back(fetchLabel(e));
    }
    return ret;
  }

  template <typename... Args>
  void emitDebugInfo(const Args&... args) {
    trap.debug(std::forward<Args>(args)...);
  }

  // In order to not emit duplicated entries for declarations, we restrict emission to only
  // Decls declared within the current "scope".
  // Depending on the whether we are extracting a primary source file or not the scope is defined as
  // follows:
  //  - not extracting a primary source file (`currentPrimarySourceFile == nullptr`): the current
  //    scope means the current module. This is used in the case of system or builtin modules.
  //  - extracting a primary source file: in this mode, we extract several files belonging to the
  //    same module one by one. In this mode, we restrict emission only to the same file ignoring
  //    all the other files.
  bool shouldEmitDeclBody(const swift::Decl& decl) {
    if (decl.getModuleContext() != &currentModule) {
      return false;
    }
    // ModuleDecl is a special case: if it passed the previous test, it is the current module
    // but it never has a source file, so we short circuit to emit it in any case
    if (!currentPrimarySourceFile || decl.getKind() == swift::DeclKind::Module) {
      return true;
    }
    if (auto context = decl.getDeclContext()) {
      return currentPrimarySourceFile == context->getParentSourceFile();
    }
    return false;
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
                               swift::TypeBase,
                               swift::IfConfigClause>;

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
    trap.emit(LocatableLocationsTrap{locatableLabel, locLabel});
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
  virtual void visit(const swift::IfConfigClause* clause) = 0;
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
  swift::ModuleDecl& currentModule;
  swift::SourceFile* currentPrimarySourceFile;
};

}  // namespace codeql
