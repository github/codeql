#pragma once

#include <filesystem>

#include <swift/AST/SourceFile.h>
#include <swift/Basic/SourceManager.h>
#include <swift/Parse/Token.h>

#include "swift/extractor/trap/TrapDomain.h"
#include "swift/extractor/infra/SwiftTagTraits.h"
#include "swift/extractor/trap/generated/TrapClasses.h"
#include "swift/extractor/infra/SwiftLocationExtractor.h"
#include "swift/extractor/infra/SwiftBodyEmissionStrategy.h"
#include "swift/extractor/infra/SwiftMangledName.h"
#include "swift/extractor/config/SwiftExtractorState.h"
#include "swift/extractor/infra/log/SwiftLogging.h"

namespace codeql {

// The main responsibilities of the SwiftDispatcher are as follows:
// * redirect specific AST node emission to a corresponding visitor (statements, expressions, etc.)
// * storing TRAP labels for emitted AST nodes (in the TrapLabelStore) to avoid re-emission
// Since SwiftDispatcher sees all the AST nodes, it also attaches a location to every 'locatable'
// node (AST nodes that are not types: declarations, statements, expressions, etc.).
class SwiftDispatcher {
  // types to be supported by assignNewLabel/fetchLabel need to be listed here
  using Handle = std::variant<const swift::Decl*,
                              const swift::Stmt*,
                              const swift::StmtCondition*,
                              const swift::StmtConditionElement*,
                              const swift::CaseLabelItem*,
                              const swift::Expr*,
                              const swift::Pattern*,
                              const swift::TypeRepr*,
                              const swift::TypeBase*,
                              const swift::CapturedValue*,
                              const swift::PoundAvailableInfo*,
                              const swift::AvailabilitySpec*>;

  template <typename E>
  static constexpr bool IsFetchable = std::is_constructible_v<Handle, const E&>;

  template <typename E>
  static constexpr bool IsLocatable =
      std::is_base_of_v<LocatableTag, TrapTagOf<E>> && !std::is_base_of_v<TypeTag, TrapTagOf<E>>;

  template <typename E>
  static constexpr bool IsDeclPointer = std::is_convertible_v<E, const swift::Decl*>;

  template <typename E>
  static constexpr bool IsTypePointer = std::is_convertible_v<E, const swift::TypeBase*>;

 public:
  // all references and pointers passed as parameters to this constructor are supposed to outlive
  // the SwiftDispatcher
  SwiftDispatcher(const swift::SourceManager& sourceManager,
                  SwiftExtractorState& state,
                  TrapDomain& trap,
                  SwiftLocationExtractor& locationExtractor,
                  SwiftBodyEmissionStrategy& bodyEmissionStrategy)
      : sourceManager{sourceManager},
        state{state},
        trap{trap},
        locationExtractor{locationExtractor},
        bodyEmissionStrategy{bodyEmissionStrategy} {}

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
    UnspecifiedElement entry{trap.createTypedLabel<UnspecifiedElementTag>()};
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
  template <typename E, std::enable_if_t<IsFetchable<E>>* = nullptr>
  TrapLabelOf<E> fetchLabel(const E& e, swift::Type type = {}) {
    if constexpr (std::is_constructible_v<bool, const E&>) {
      if (!e) {
        // this will be treated on emission
        return undefined_label;
      }
    }
    auto& stored = store[e];
    if (!stored.valid()) {
      auto inserted = fetching.insert(e);
      assert(inserted.second && "detected infinite fetchLabel recursion");
      stored = createLabel(e, type);
      fetching.erase(e);
    }
    return TrapLabelOf<E>::unsafeCreateFromUntyped(stored);
  }

  // convenience `fetchLabel` overload for `swift::Type` (which is just a wrapper for
  // `swift::TypeBase*`)
  TrapLabel<TypeTag> fetchLabel(swift::Type t) { return fetchLabel(t.getPointer()); }

  TrapLabel<AstNodeTag> fetchLabel(swift::ASTNode node) {
    return fetchLabelFromUnion<AstNodeTag>(node);
  }

  template <typename E, std::enable_if_t<IsFetchable<E*>>* = nullptr>
  TrapLabelOf<E> fetchLabel(const E& e) {
    return fetchLabel(&e);
  }

  // convenience methods for structured C++ creation
  template <typename E>
  auto createEntry(const E& e) {
    auto found = store.find(&e);
    assert(found != store.end() && "createEntry called on non-fetched label");
    auto label = TrapLabel<ConcreteTrapTagOf<E>>::unsafeCreateFromUntyped(found->second);
    if constexpr (IsLocatable<E>) {
      locationExtractor.attachLocation(sourceManager, e, label);
    }
    return TrapClassOf<E>{label};
  }

  // used to create a new entry for entities that should not be cached
  // an example is swift::Argument, that are created on the fly and thus have no stable pointer
  template <typename E>
  auto createUncachedEntry(const E& e) {
    auto label = trap.createTypedLabel<TrapTagOf<E>>();
    locationExtractor.attachLocation(sourceManager, &e, label);
    return TrapClassOf<E>{label};
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

  void emitComment(swift::Token& comment) {
    CommentsTrap entry{trap.createTypedLabel<CommentTag>(), comment.getRawText().str()};
    trap.emit(entry);
    locationExtractor.attachLocation(sourceManager, comment, entry.id);
  }

 protected:
  void visitPending() {
    while (!toBeVisited.empty()) {
      auto [next, type] = toBeVisited.back();
      toBeVisited.pop_back();
      // TODO: add tracing logs for visited stuff, maybe within the translators?
      std::visit([this, type = type](const auto* e) { visit(e, type); }, next);
    }
  }

 private:
  template <typename E>
  UntypedTrapLabel createLabel(const E& e, swift::Type type) {
    if constexpr (IsDeclPointer<E> || IsTypePointer<E>) {
      if (auto mangledName = name(e)) {
        if (shouldVisit(e)) {
          toBeVisited.emplace_back(e, type);
        }
        return trap.createLabel(mangledName);
      }
    }
    // we always need to visit unnamed things
    toBeVisited.emplace_back(e, type);
    return trap.createLabel();
  }

  template <typename E>
  bool shouldVisit(const E& e) {
    if constexpr (IsDeclPointer<E>) {
      encounteredModules.insert(e->getModuleContext());
      if (bodyEmissionStrategy.shouldEmitDeclBody(*e)) {
        extractedDeclaration(e);
        return true;
      }
      skippedDeclaration(e);
      return false;
    }
    return true;
  }

  void extractedDeclaration(const swift::Decl* decl) {
    if (isLazyDeclaration(decl)) {
      state.emittedDeclarations.insert(decl);
    }
  }
  void skippedDeclaration(const swift::Decl* decl) {
    if (isLazyDeclaration(decl)) {
      state.pendingDeclarations.insert(decl);
    }
  }

  static bool isLazyDeclaration(const swift::Decl* decl) {
    swift::ModuleDecl* module = decl->getModuleContext();
    return module->isBuiltinModule() || module->getName().str() == "__ObjC" ||
           module->isNonSwiftModule();
  }

  template <typename T, typename = void>
  struct HasSize : std::false_type {};

  template <typename T>
  struct HasSize<T, decltype(std::declval<T>().size(), void())> : std::true_type {};

  template <typename T, typename = void>
  struct HasId : std::false_type {};

  template <typename T>
  struct HasId<T, decltype(std::declval<T>().id, void())> : std::true_type {};

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

  virtual SwiftMangledName name(const swift::Decl* decl) = 0;
  virtual SwiftMangledName name(const swift::TypeBase* type) = 0;
  virtual void visit(const swift::Decl* decl) = 0;
  virtual void visit(const swift::Stmt* stmt) = 0;
  virtual void visit(const swift::StmtCondition* cond) = 0;
  virtual void visit(const swift::StmtConditionElement* cond) = 0;
  virtual void visit(const swift::PoundAvailableInfo* availability) = 0;
  virtual void visit(const swift::AvailabilitySpec* spec) = 0;
  virtual void visit(const swift::CaseLabelItem* item) = 0;
  virtual void visit(const swift::Expr* expr) = 0;
  virtual void visit(const swift::Pattern* pattern) = 0;
  virtual void visit(const swift::TypeRepr* typeRepr, swift::Type type) = 0;
  virtual void visit(const swift::TypeBase* type) = 0;
  virtual void visit(const swift::CapturedValue* capture) = 0;

  template <typename T, std::enable_if<!std::is_base_of_v<swift::TypeRepr, T>>* = nullptr>
  void visit(const T* e, swift::Type) {
    visit(e);
  }

  const swift::SourceManager& sourceManager;
  SwiftExtractorState& state;
  TrapDomain& trap;
  std::unordered_map<Handle, UntypedTrapLabel> store;
  std::unordered_set<Handle> fetching;
  std::vector<std::pair<Handle, swift::Type>> toBeVisited;
  SwiftLocationExtractor& locationExtractor;
  SwiftBodyEmissionStrategy& bodyEmissionStrategy;
  std::unordered_set<swift::ModuleDecl*> encounteredModules;
  Logger logger{"dispatcher"};
};

}  // namespace codeql
