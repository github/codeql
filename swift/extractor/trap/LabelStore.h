#ifndef SWIFT_TRAP_LABELSTORE_H_
#define SWIFT_TRAP_LABELSTORE_H_

#include <cassert>
#include <optional>
#include <unordered_map>

#include <swift/AST/ASTVisitor.h>

#include "extractor/trap/Label.h"
#include "extractor/trap/TagTraits.h"
#include "extractor/trap/Tags.h"

namespace codeql {

namespace trap {

class LabelStore {
  std::unordered_map<const void*, uint64_t> store_;

 public:
  template <typename T>
  std::optional<Label<ToTag<T>>> get(const T* e) {
    if (auto found = store_.find(getCanonicalPtr(e)); found != store_.end()) {
      return Label<ToTag<T>>{found->second};
    }
    return std::nullopt;
  }

  template <typename T>
  void insert(const T* e, Label<ToTag<T>> l) {
    auto [_, inserted] = store_.emplace(getCanonicalPtr(e), l.id_);
    assert(inserted && "already inserted");
  }

 private:
};

}  // namespace trap
}  // namespace codeql

#endif  // SWIFT_TRAP_LABELSTORE_H_
