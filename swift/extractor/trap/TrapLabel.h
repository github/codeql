#pragma once

#include <cassert>
#include <iomanip>
#include <iostream>
#include <string>

namespace codeql {

class UntypedTrapLabel {
  uint64_t id_;

  friend class std::hash<UntypedTrapLabel>;
  template <typename Tag>
  friend class TrapLabel;

  static constexpr uint64_t undefined = 0xffffffffffffffff;

 protected:
  UntypedTrapLabel() : id_{undefined} {}
  UntypedTrapLabel(uint64_t id) : id_{id} {}

 public:
  friend std::ostream& operator<<(std::ostream& out, UntypedTrapLabel l) {
    // TODO: this is a temporary fix to catch us from outputting undefined labels to trap
    // this should be moved to a validity check, probably aided by code generation and carried out
    // by `SwiftDispatcher`
    assert(l.id_ != undefined && "outputting an undefined label!");
    out << '#' << std::hex << l.id_ << std::dec;
    return out;
  }

  friend bool operator==(UntypedTrapLabel lhs, UntypedTrapLabel rhs) { return lhs.id_ == rhs.id_; }
};

template <typename TagParam>
class TrapLabel : public UntypedTrapLabel {
  template <typename OtherTag>
  friend class TrapLabel;

  using UntypedTrapLabel::UntypedTrapLabel;

 public:
  using Tag = TagParam;

  TrapLabel() = default;

  // The caller is responsible for ensuring ID uniqueness.
  static TrapLabel unsafeCreateFromExplicitId(uint64_t id) { return {id}; }
  static TrapLabel unsafeCreateFromUntyped(UntypedTrapLabel label) { return {label.id_}; }

  template <typename OtherTag>
  TrapLabel(const TrapLabel<OtherTag>& other) : UntypedTrapLabel(other) {
    static_assert(std::is_base_of_v<Tag, OtherTag>, "wrong label assignment!");
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
