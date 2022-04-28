#pragma once

#include <iomanip>
#include <iostream>
#include <string>

#include "swift/extractor/trap/TrapTagTraits.h"
#include "swift/extractor/trap/TrapTags.h"

namespace codeql {

class UntypedTrapLabel {
  uint64_t id_;

  friend class std::hash<UntypedTrapLabel>;

 protected:
  UntypedTrapLabel() : id_{0xffffffffffffffff} {}
  UntypedTrapLabel(uint64_t id) : id_{id} {}

 public:
  friend std::ostream& operator<<(std::ostream& out, UntypedTrapLabel l) {
    out << '#' << std::hex << l.id_ << std::dec;
    return out;
  }

  friend bool operator==(UntypedTrapLabel lhs, UntypedTrapLabel rhs) { return lhs.id_ == rhs.id_; }
};

template <typename Tag>
class TrapLabel : public UntypedTrapLabel {
  template <typename OtherTag>
  friend class TrapLabel;

  using UntypedTrapLabel::UntypedTrapLabel;

 public:
  TrapLabel() = default;

  template <typename OtherTag>
  TrapLabel(const TrapLabel<OtherTag>& other) : UntypedTrapLabel(other) {
    // we temporarily need to bypass the label type system for unknown AST nodes and types
    if constexpr (std::is_same_v<Tag, UnknownAstNodeTag>) {
      static_assert(std::is_base_of_v<AstNodeTag, OtherTag>, "wrong label assignment!");
    } else if constexpr (std::is_same_v<Tag, UnknownTypeTag>) {
      static_assert(std::is_base_of_v<TypeTag, OtherTag>, "wrong label assignment!");
    } else {
      static_assert(std::is_base_of_v<Tag, OtherTag>, "wrong label assignment!");
    }
  }
};

inline auto trapQuoted(const std::string& s) {
  return std::quoted(s, '"', '"');
}

}  // namespace codeql

namespace std {
template <>
struct hash<codeql::UntypedTrapLabel> {
  size_t operator()(const codeql::UntypedTrapLabel& l) const noexcept {
    return std::hash<uint64_t>{}(l.id_);
  }
};
}  // namespace std
