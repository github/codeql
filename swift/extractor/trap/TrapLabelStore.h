#pragma once

#include <cassert>
#include <optional>
#include <unordered_map>

#include <swift/AST/ASTVisitor.h>

#include "swift/extractor/trap/TrapLabel.h"
#include "swift/extractor/trap/TrapTagTraits.h"
#include "swift/extractor/trap/generated/TrapTags.h"

namespace codeql {

// the following is needed to avoid the problem of subclass pointers not necessarily coinciding
// with superclass ones in case of multiple inheritance
inline const void* getCanonicalPtr(const swift::Decl* e) {
  return e;
}
inline const void* getCanonicalPtr(const swift::Stmt* e) {
  return e;
}
inline const void* getCanonicalPtr(const swift::Expr* e) {
  return e;
}
inline const void* getCanonicalPtr(const swift::Pattern* e) {
  return e;
}
inline const void* getCanonicalPtr(const swift::TypeRepr* e) {
  return e;
}
inline const void* getCanonicalPtr(const swift::TypeBase* e) {
  return e;
}

// The extraction is done in a lazy/on-demand fashion:
// Each emitted TRAP entry for an AST node gets a TRAP label assigned to it.
// To avoid re-emission, we store the "AST node <> label" entry in the TrapLabelStore.
class TrapLabelStore {
 public:
  template <typename T>
  std::optional<TrapLabel<ToTag<T>>> get(const T* e) {
    if (auto found = store_.find(getCanonicalPtr(e)); found != store_.end()) {
      return TrapLabel<ToTag<T>>::unsafeCreateFromExplicitId(found->second);
    }
    return std::nullopt;
  }

  template <typename T>
  void insert(const T* e, TrapLabel<ToTag<T>> l) {
    auto [_, inserted] = store_.emplace(getCanonicalPtr(e), l.id_);
    assert(inserted && "already inserted");
  }

 private:
  std::unordered_map<const void*, uint64_t> store_;
};

}  // namespace codeql
