#pragma once

#include <memory>
#include <sstream>

#include "swift/extractor/trap/TrapLabel.h"
#include "swift/extractor/infra/file/TargetFile.h"

namespace codeql {

// Abstracts a given trap output file, with its own universe of trap labels
class TrapDomain {
  TargetFile& out_;

 public:
  explicit TrapDomain(TargetFile& out) : out_{out} {}

  template <typename Entry>
  void emit(const Entry& e) {
    print(e);
  }

  template <typename... Args>
  void debug(const Args&... args) {
    print("/* DEBUG:");
    print(args...);
    print("*/");
  }

  template <typename Tag>
  TrapLabel<Tag> createLabel() {
    auto ret = allocateLabel<Tag>();
    assignStar(ret);
    return ret;
  }

  template <typename Tag, typename... Args>
  TrapLabel<Tag> createLabel(Args&&... args) {
    auto ret = allocateLabel<Tag>();
    assignKey(ret, std::forward<Args>(args)...);
    return ret;
  }

 private:
  uint64_t id_{0};

  template <typename Tag>
  TrapLabel<Tag> allocateLabel() {
    return TrapLabel<Tag>::unsafeCreateFromExplicitId(id_++);
  }

  template <typename... Args>
  void print(const Args&... args) {
    (out_ << ... << args) << '\n';
  }

  template <typename Tag>
  void assignStar(TrapLabel<Tag> label) {
    print(label, "=*");
  }

  template <typename Tag>
  void assignKey(TrapLabel<Tag> label, const std::string& key) {
    // prefix the key with the id to guarantee the same key is not used wrongly with different tags
    auto prefixed = std::string(Tag::prefix) + '_' + key;
    print(label, "=@", trapQuoted(prefixed));
  }

  template <typename Tag, typename... Args>
  void assignKey(TrapLabel<Tag> label, const Args&... keyParts) {
    std::ostringstream oss;
    (oss << ... << keyParts);
    assignKey(label, oss.str());
  }
};

}  // namespace codeql
