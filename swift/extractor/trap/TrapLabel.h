#pragma once

#include <cassert>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>
#include "absl/numeric/bits.h"
#include <binlog/binlog.hpp>
#include <cmath>
#include <charconv>

namespace codeql {

struct UndefinedTrapLabel {};

constexpr UndefinedTrapLabel undefined_label{};

class UntypedTrapLabel {
  uint64_t id_;

  friend class std::hash<UntypedTrapLabel>;
  template <typename Tag>
  friend class TrapLabel;
  BINLOG_ADAPT_STRUCT_FRIEND;

  static constexpr uint64_t undefined = 0xffffffffffffffff;

 public:
  UntypedTrapLabel() : id_{undefined} {}
  explicit UntypedTrapLabel(uint64_t id) : id_{id} { assert(id != undefined); }
  UntypedTrapLabel(UndefinedTrapLabel) : UntypedTrapLabel() {}

  bool valid() const { return id_ != undefined; }
  explicit operator bool() const { return valid(); }

  friend std::ostream& operator<<(std::ostream& out, UntypedTrapLabel l) {
    // TODO: this is a temporary fix to catch us from outputting undefined labels to trap
    // this should be moved to a validity check, probably aided by code generation and carried out
    // by `SwiftDispatcher`
    assert(l && "outputting an undefined label!");
    out << '#' << std::hex << l.id_ << std::dec;
    return out;
  }

  std::string str() const {
    std::string ret(strSize(), '\0');
    ret[0] = '#';
    std::to_chars(ret.data() + 1, ret.data() + ret.size(), id_, 16);
    return ret;
  }

  friend bool operator==(UntypedTrapLabel lhs, UntypedTrapLabel rhs) { return lhs.id_ == rhs.id_; }

 private:
  size_t strSize() const {
    if (id_ == 0) return 2;  // #0
    // Number of hex digits is ceil(bit_width(id) / 4), but C++ integer division can only do floor.
    return /* # */ 1 + /* hex digits */ 1 + (absl::bit_width(id_) - 1) / 4;
  }

  friend bool operator!=(UntypedTrapLabel lhs, UntypedTrapLabel rhs) { return lhs.id_ != rhs.id_; }
};

template <typename TagParam>
class TrapLabel : public UntypedTrapLabel {
  template <typename OtherTag>
  friend class TrapLabel;

  using UntypedTrapLabel::UntypedTrapLabel;

 public:
  using Tag = TagParam;

  TrapLabel() = default;
  TrapLabel(UndefinedTrapLabel) : TrapLabel() {}

  TrapLabel& operator=(UndefinedTrapLabel) {
    *this = TrapLabel{};
    return *this;
  }

  // The caller is responsible for ensuring ID uniqueness.
  static TrapLabel unsafeCreateFromExplicitId(uint64_t id) { return TrapLabel{id}; }
  static TrapLabel unsafeCreateFromUntyped(UntypedTrapLabel label) { return TrapLabel{label.id_}; }

  template <typename SourceTag>
  TrapLabel(const TrapLabel<SourceTag>& other) : UntypedTrapLabel(other) {
    static_assert(std::is_base_of_v<Tag, SourceTag>, "wrong label assignment!");
  }
};

// wrapper class to allow directly assigning a vector of TrapLabel<A> to a vector of
// TrapLabel<B> if B is a base of A, using move semantics rather than copying
template <typename TagParam>
struct TrapLabelVectorWrapper {
  using Tag = TagParam;

  std::vector<TrapLabel<TagParam>> data;

  template <typename DestinationTag>
  operator std::vector<TrapLabel<DestinationTag>>() && {
    static_assert(std::is_base_of_v<DestinationTag, Tag>, "wrong label assignment!");
    // reinterpret_cast is safe because TrapLabel instances differ only on the type, not the
    // underlying data
    return std::move(reinterpret_cast<std::vector<TrapLabel<DestinationTag>>&>(data));
  }
};

inline auto trapQuoted(const std::string_view& s) {
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

namespace mserialize {
// log labels using their string representation, using binlog/mserialize internal plumbing
template <>
struct CustomTag<codeql::UntypedTrapLabel, void> : detail::BuiltinTag<std::string> {
  using T = codeql::UntypedTrapLabel;
};

template <typename Tag>
struct CustomTag<codeql::TrapLabel<Tag>, void> : detail::BuiltinTag<std::string> {
  using T = codeql::TrapLabel<Tag>;
};

template <>
struct CustomSerializer<codeql::UntypedTrapLabel, void> {
  template <typename OutputStream>
  static void serialize(codeql::UntypedTrapLabel label, OutputStream& out) {
    mserialize::serialize(label.str(), out);
  }

  static size_t serialized_size(codeql::UntypedTrapLabel label) {
    return sizeof(std::uint32_t) + label.strSize();
  }
};

template <typename Tag>
struct CustomSerializer<codeql::TrapLabel<Tag>, void> : CustomSerializer<codeql::UntypedTrapLabel> {
};

}  // namespace mserialize
