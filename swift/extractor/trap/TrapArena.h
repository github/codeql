//
// Created by redsun82 on 18.01.22.
//

#pragma once

#include <iostream>
#include <sstream>
#include <vector>

#include "swift/extractor/trap/TrapLabel.h"

namespace codeql {

// TrapArena has the responsibilities to
// * allocate distinct trap #-labels outputting their assignment to '*' or a @-keys to a trap output
// * forwarding trap entries to said output
// TODO: split or move these responsibilities into separate classes
class TrapArena {
 public:
  explicit TrapArena(std::ostream& out) : out_{out} {}

  // get a new label for *
  template <typename Tag>
  TrapLabel<Tag> getLabel() {
    auto ret = allocateLabel<Tag>();
    print(ret, "=*");
    return ret;
  }

  // get a new label for an @-key
  template <typename Tag>
  TrapLabel<Tag> getLabel(const std::string& key) {
    auto ret = allocateLabel<Tag>();
    // prefix the key with the id to guarantee the same key is not used wrongly with different tags
    auto prefixed = std::string(Tag::prefix) + '_' + key;
    print(ret, "=@", quoted(prefixed));
    return ret;
  }

  // same as getLabel(const std::string&) above, concatenating keyParts
  template <typename Tag, typename... Args>
  TrapLabel<Tag> getLabel(const Args&... keyParts) {
    std::ostringstream oss;
    (oss << ... << keyParts);
    return getLabel<Tag>(oss.str());
  }

  // emit a trap entry
  template <typename Entry>
  void emit(const Entry& e) {
    print(e);
  }

 private:
  template <typename... Args>
  void print(const Args&... args) {
    (out_ << ... << args) << '\n';
  }

  template <typename Tag>
  TrapLabel<Tag> allocateLabel() {
    return {id_++};
  }

  uint64_t id_{0};
  std::ostream& out_;
};

}  // namespace codeql
