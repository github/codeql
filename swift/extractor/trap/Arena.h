#ifndef SWIFT_TRAP_ARENA_H_
#define SWIFT_TRAP_ARENA_H_

#include <iostream>
#include <sstream>
#include <vector>

#include "trap/Label.h"

namespace codeql::trap {

class Arena {
 public:
  template <typename... Outs>
  explicit Arena(Outs&... outs) : outs_{&outs...} {}

  template <typename Tag>
  Label<Tag> getLabel() {  // get a new label for *
    auto ret = allocateLabel<Tag>();
    print(ret, "=*");
    return ret;
  }

  template <typename Tag>
  Label<Tag> getLabel(const std::string& key) {  // get a new label for an @-key
    auto ret = allocateLabel<Tag>();
    // prefix the key with the id to guarantee the same key is not used wrongly with different tags
    auto prefixed = std::string(Tag::prefix) + '_' + key;
    print(ret, "=@", quoted(prefixed));
    return ret;
  }

  template <typename Tag, typename... Args>
  Label<Tag> getLabel(const Args&... keyParts) {
    std::ostringstream oss;
    (oss << ... << keyParts);
    return getLabel<Tag>(oss.str());
  }

  template <typename Entry>
  void emit(const Entry& e) {
    print(e);
  }

 private:
  template <typename... Args>
  void print(const Args&... args) {
    for (auto out : outs_) {
      (*out << ... << args) << '\n';
    }
  }

  template <typename Tag>
  Label<Tag> allocateLabel() {
    return {id_++};
  }

  uint64_t id_{0};
  std::vector<std::ostream*> outs_;
};

}  // namespace codeql::trap
#endif  // SWIFT_TRAP_ARENA_H_
