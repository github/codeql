#pragma once

#include <memory>
#include "swift/extractor/trap/TrapLabel.h"

namespace codeql {

// Sink for trap emissions and label assignments. This abstracts away `ofstream` operations
// like `ofstream`, an explicit bool operator is provided, that return false if something
// went wrong
// TODO better error handling
class TrapOutput {
  std::ostream& out_;

 public:
  explicit TrapOutput(std::ostream& out) : out_{out} {}

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

  template <typename Entry>
  void emit(const Entry& e) {
    print(e);
  }

  template <typename... Args>
  void debug(const Args&... args) {
    out_ << "// DEBUG: ";
    (out_ << ... << args) << '\n';
  }

 private:
  template <typename... Args>
  void print(const Args&... args) {
    (out_ << ... << args) << '\n';
  }
};

}  // namespace codeql
