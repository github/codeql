#pragma once

#include <variant>
#include <cassert>
#include <optional>
#include <unordered_map>

#include <swift/AST/ASTVisitor.h>

#include "swift/extractor/trap/TrapLabel.h"
#include "swift/extractor/trap/TrapTagTraits.h"
#include "swift/extractor/trap/generated/TrapTags.h"

namespace codeql {

// The extraction is done in a lazy/on-demand fashion:
// Each emitted TRAP entry for an AST node gets a TRAP label assigned to it.
// To avoid re-emission, we store the "AST node <> label" entry in the TrapLabelStore.
// The template parameters `Ts...` indicate to what entity types we restrict the storage
template <typename... Ts>
class TrapLabelStore {
 public:
  using Handle = std::variant<Ts...>;

  template <typename T>
  std::optional<TrapLabelOf<T>> get(const T& e) {
    if (auto found = store_.find(e); found != store_.end()) {
      return TrapLabelOf<T>::unsafeCreateFromUntyped(found->second);
    }
    return std::nullopt;
  }

  template <typename T>
  void insert(const T& e, TrapLabelOf<T> l) {
    auto [_, inserted] = store_.emplace(e, l);
    assert(inserted && "already inserted");
  }

 private:
  std::unordered_map<Handle, UntypedTrapLabel> store_;
};

}  // namespace codeql
