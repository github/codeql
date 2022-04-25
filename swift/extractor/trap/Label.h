#ifndef SWIFT_TRAP_LABEL_H_
#define SWIFT_TRAP_LABEL_H_

#include <iomanip>
#include <iostream>
#include <string>

#include "trap/TagTraits.h"
#include "trap/Tags.h"

namespace codeql::trap {

class UntypedLabel {
  uint64_t id_;

  friend class LabelStore;
  friend class std::hash<UntypedLabel>;

 protected:
  UntypedLabel() : id_{0xffffffffffffffff} {}
  UntypedLabel(uint64_t id) : id_{id} {}

 public:
  friend std::ostream& operator<<(std::ostream& out, UntypedLabel l) {
    out << '#' << l.id_;
    return out;
  }

  friend bool operator==(UntypedLabel lhs, UntypedLabel rhs) { return lhs.id_ == rhs.id_; }
};

template <typename Tag>
class Label : public UntypedLabel {
  friend class Arena;
  friend class LabelStore;

  template <typename OtherTag>
  friend class Label;

  using UntypedLabel::UntypedLabel;

 public:
  Label() = default;

  template <typename OtherTag>
  Label(const Label<OtherTag>& other) : UntypedLabel(other) {
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

inline auto quoted(const std::string& s) {
  return std::quoted(s, '"', '"');
}

}  // namespace codeql::trap

namespace std {
template <>
struct hash<codeql::trap::UntypedLabel> {
  size_t operator()(const codeql::trap::UntypedLabel& l) const noexcept {
    return std::hash<uint64_t>{}(l.id_);
  }
};
}  // namespace std
#endif  // SWIFT_TRAP_LABEL_H_
