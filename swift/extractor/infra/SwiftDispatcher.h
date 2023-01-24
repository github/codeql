#pragma once

#include <filesystem>

#include <swift/AST/SourceFile.h>
#include <swift/Basic/SourceManager.h>
#include <swift/Parse/Token.h>

#include "swift/extractor/trap/TrapLabelStore.h"
#include "swift/extractor/trap/TrapDomain.h"
#include "swift/extractor/infra/SwiftTagTraits.h"
#include "swift/extractor/trap/generated/TrapClasses.h"
#include "swift/extractor/infra/SwiftLocationExtractor.h"

namespace codeql {

// The main responsibilities of the SwiftDispatcher are as follows:
// * redirect specific AST node emission to a corresponding visitor (statements, expressions, etc.)
// * storing TRAP labels for emitted AST nodes (in the TrapLabelStore) to avoid re-emission
// Since SwiftDispatcher sees all the AST nodes, it also attaches a location to every 'locatable'
// node (AST nodes that are not types: declarations, statements, expressions, etc.).
class SwiftDispatcher {
  // types to be supported by assignNewLabel/fetchLabel need to be listed here
  using Store = TrapLabelStore<const swift::Decl*,
                               const swift::Stmt*,
                               const swift::StmtCondition*,
                               const swift::StmtConditionElement*,
                               const swift::CaseLabelItem*,
                               const swift::Expr*,
                               const swift::Pattern*,
                               const swift::TypeRepr*,
                               const swift::TypeBase*>;

  template <typename E>
  static constexpr bool IsStorable = std::is_constructible_v<Store::Handle, const E&>;

  template <typename E>
  static constexpr bool IsLocatable = std::is_base_of_v<LocatableTag, TrapTagOf<E>>;

 public:
  // all references and pointers passed as parameters to this constructor are supposed to outlive
  // the SwiftDispatcher
  SwiftDispatcher(const swift::SourceManager& sourceManager,
                  TrapDomain& trap,
                  swift::ModuleDecl& currentModule,
                  swift::SourceFile* currentPrimarySourceFile = nullptr)
      : sourceManager{sourceManager},
        trap{trap},
        currentModule{currentModule},
        currentPrimarySourceFile{currentPrimarySourceFile},
        locationExtractor(trap) {
    if (currentPrimarySourceFile) {
      // we make sure the file is in the trap output even if the source is empty
      locationExtractor.emitFile(currentPrimarySourceFile->getFilename());
    }
  }

  const std::unordered_set<swift::ModuleDecl*> getEncounteredModules() && {
    return std::move(encounteredModules);
  }

  template <typename Entry>
  void emit(Entry&& entry) {
    bool valid = true;
    entry.forEachLabel([&valid, &entry, this](const char* field, int index, auto& label) {
      using Label = std::remove_reference_t<decltype(label)>;
      if (!label.valid()) {
        std::cerr << entry.NAME << " has undefined " << field;
        if (index >= 0) {
          std::cerr << '[' << index << ']';
        }
        if constexpr (std::is_base_of_v<typename Label::Tag, UnspecifiedElementTag>) {
          std::cerr << ", replacing with unspecified element\n";
          label = emitUnspecified(idOf(entry), field, index);
        } else {
          std::cerr << ", skipping emission\n";
          valid = false;
        }
      }
    });
    if (valid) {
      trap.emit(entry);
    }
  }

  template <typename Entry>
  void emit(std::optional<Entry>&& entry) {
    if (entry) {
      emit(std::move(*entry));
    }
  }

  template <typename... Cases>
  void emit(std::variant<Cases...>&& entry) {
    std::visit([this](auto&& e) { this->emit(std::move(e)); }, std::move(entry));
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

  TrapLabel<UnspecifiedElementTag> emitUnspecified(std::optional<TrapLabel<ElementTag>>&& parent,
                                                   const char* property,
                                                   int index) {
    UnspecifiedElement entry{trap.createLabel<UnspecifiedElementTag>()};
    entry.error = "element was unspecified by the extractor";
    entry.parent = std::move(parent);
    entry.property = property;
    if (index >= 0) {
      entry.index = index;
    }
    trap.emit(entry);
    return entry.id;
  }

  template <typename E>
  std::optional<TrapLabel<ElementTag>> idOf(const E& entry) {
    if constexpr (HasId<E>::value) {
      return entry.id;
    } else {
      return std::nullopt;
    }
  }

  // This method gives a TRAP label for already emitted AST node.
  // If the AST node was not emitted yet, then the emission is dispatched to a corresponding
  // visitor (see `visit(T *)` methods below).
  template <typename E, typename... Args, std::enable_if_t<IsStorable<E>>* = nullptr>
  TrapLabelOf<E> fetchLabel(const E& e, Args&&... args) {
    if constexpr (std::is_constructible_v<bool, const E&>) {
      if (!e) {
        // this will be treated on emission
        return undefined_label;
      }
    }
    // this is required so we avoid any recursive loop: a `fetchLabel` during the visit of `e` might
    // end up calling `fetchLabel` on `e` itself, so we want the visit of `e` to call `fetchLabel`
    // only after having called `assignNewLabel` on `e`.
    assert(std::holds_alternative<std::monostate>(waitingForNewLabel) &&
           "fetchLabel called before assignNewLabel");
    if (auto l = store.get(e)) {
      return *l;
    }
    waitingForNewLabel = e;
    visit(e, std::forward<Args>(args)...);
    // TODO when everything is moved to structured C++ classes, this should be moved to createEntry
    if (auto l = store.get(e)) {
      if constexpr (IsLocatable<E>) {
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

  template <typename E, std::enable_if_t<IsStorable<E*>>* = nullptr>
  TrapLabelOf<E> fetchLabel(const E& e) {
    return fetchLabel(&e);
  }

  // Due to the lazy emission approach, we must assign a label to a corresponding AST node before
  // it actually gets emitted to handle recursive cases such as recursive calls, or recursive type
  // declarations
  template <typename E, typename... Args, std::enable_if_t<IsStorable<E>>* = nullptr>
  TrapLabel<ConcreteTrapTagOf<E>> assignNewLabel(const E& e, Args&&... args) {
    assert(waitingForNewLabel == Store::Handle{e} && "assignNewLabel called on wrong entity");
    auto label = trap.createLabel<ConcreteTrapTagOf<E>>(std::forward<Args>(args)...);
    store.insert(e, label);
    waitingForNewLabel = std::monostate{};
    return label;
  }

  template <typename E, typename... Args, std::enable_if_t<IsStorable<E*>>* = nullptr>
  TrapLabel<ConcreteTrapTagOf<E>> assignNewLabel(const E& e, Args&&... args) {
    return assignNewLabel(&e, std::forward<Args>(args)...);
  }

  // convenience methods for structured C++ creation
  template <typename E, typename... Args>
  auto createEntry(const E& e, Args&&... args) {
    return TrapClassOf<E>{assignNewLabel(e, std::forward<Args>(args)...)};
  }

  // used to create a new entry for entities that should not be cached
  // an example is swift::Argument, that are created on the fly and thus have no stable pointer
  template <typename E, typename... Args>
  auto createUncachedEntry(const E& e, Args&&... args) {
    auto label = trap.createLabel<TrapTagOf<E>>(std::forward<Args>(args)...);
    attachLocation(&e, label);
    return TrapClassOf<E>{label};
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
  template <typename Arg, typename... Args>
  auto fetchOptionalLabel(Arg&& arg, Args&&... args) -> std::optional<decltype(fetchLabel(arg))> {
    if (arg) {
      return fetchLabel(arg, std::forward<Args>(args)...);
    }
    return std::nullopt;
  }

  // map `fetchLabel` on the iterable `arg`
  // universal reference `Arg&&` is used to catch both temporary and non-const references, not
  // for perfect forwarding
  template <typename Iterable>
  auto fetchRepeatedLabels(Iterable&& arg) {
    using Label = decltype(fetchLabel(*arg.begin()));
    TrapLabelVectorWrapper<typename Label::Tag> ret;
    if constexpr (HasSize<Iterable>::value) {
      ret.data.reserve(arg.size());
    }
    for (auto&& e : arg) {
      ret.data.push_back(fetchLabel(e));
    }
    return ret;
  }

  template <typename... Args>
  void emitDebugInfo(const Args&... args) {
    trap.debug(args...);
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
  // This is also used to register the modules we encounter.
  // TODO calls to this function should be taken away from `DeclVisitor` and moved around with a
  // clearer separation between naming entities (some decls, all types), deciding whether to emit
  // them and finally visiting emitting the contents of the entity (which should remain in the
  // visitors). Then this double responsibility (carrying out the test and registering encountered
  // modules) should also be cleared out
  bool shouldEmitDeclBody(const swift::Decl& decl) {
    auto module = decl.getModuleContext();
    if (module != &currentModule) {
      encounteredModules.insert(module);
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

  void emitComment(swift::Token& comment) {
    CommentsTrap entry{trap.createLabel<CommentTag>(), comment.getRawText().str()};
    trap.emit(entry);
    attachLocation(comment.getRange().getStart(), comment.getRange().getEnd(), entry.id);
  }

 private:
  template <typename T, typename = void>
  struct HasSize : std::false_type {};

  template <typename T>
  struct HasSize<T, decltype(std::declval<T>().size(), void())> : std::true_type {};

  template <typename T, typename = void>
  struct HasId : std::false_type {};

  template <typename T>
  struct HasId<T, decltype(std::declval<T>().id, void())> : std::true_type {};

  void attachLocation(swift::SourceLoc start,
                      swift::SourceLoc end,
                      TrapLabel<LocatableTag> locatableLabel) {
    locationExtractor.attachLocation(sourceManager, start, end, locatableLabel);
  }

  template <typename Tag, typename... Ts>
  TrapLabel<Tag> fetchLabelFromUnion(const llvm::PointerUnion<Ts...> u) {
    TrapLabel<Tag> ret{};
    // with logical op short-circuiting, this will stop trying on the first successful fetch
    bool unionCaseFound = (... || fetchLabelFromUnionCase<Tag, Ts>(u, ret));
    if (!unionCaseFound) {
      // TODO emit error/warning here
      return undefined_label;
    }
    return ret;
  }

  template <typename Tag, typename T, typename... Ts>
  bool fetchLabelFromUnionCase(const llvm::PointerUnion<Ts...> u, TrapLabel<Tag>& output) {
    // we rely on the fact that when we extract `ASTNode` instances (which only happens
    // on `BraceStmt`/`IfConfigDecl` elements), we cannot encounter a standalone `TypeRepr` there,
    // so we skip this case; extracting `TypeRepr`s here would be problematic as we would not be
    // able to provide the corresponding type
    if constexpr (!std::is_same_v<T, swift::TypeRepr*>) {
      if (auto e = u.template dyn_cast<T>()) {
        output = fetchLabel(e);
        return true;
      }
    }
    return false;
  }

  virtual void visit(const swift::Decl* decl) = 0;
  virtual void visit(const swift::Stmt* stmt) = 0;
  virtual void visit(const swift::StmtCondition* cond) = 0;
  virtual void visit(const swift::StmtConditionElement* cond) = 0;
  virtual void visit(const swift::CaseLabelItem* item) = 0;
  virtual void visit(const swift::Expr* expr) = 0;
  virtual void visit(const swift::Pattern* pattern) = 0;
  virtual void visit(const swift::TypeRepr* typeRepr, swift::Type type) = 0;
  virtual void visit(const swift::TypeBase* type) = 0;

  const swift::SourceManager& sourceManager;
  TrapDomain& trap;
  Store store;
  Store::Handle waitingForNewLabel{std::monostate{}};
  swift::ModuleDecl& currentModule;
  swift::SourceFile* currentPrimarySourceFile;
  std::unordered_set<swift::ModuleDecl*> encounteredModules;
  SwiftLocationExtractor locationExtractor;
};

}  // namespace codeql
