#pragma once

#include "swift/extractor/trap/TrapLabel.h"
#include "swift/extractor/trap/TrapOutput.h"

namespace codeql {

class TrapFile {
  uint64_t id{0};
  TrapOutput out;

 public:
  template <typename Tag>
  TrapLabel<Tag> createLabel() {
    auto ret = allocateLabel<Tag>();
    out.assignStar(ret);
    return ret;
  }

  template <typename Tag, typename... Args>
  TrapLabel<Tag> createLabel(Args&&... args) {
    auto ret = allocateLabel<Tag>();
    out.assignKey(ret, std::forward<Args>(args)...);
    return ret;
  }

  template <typename... Args>
  void debug(const Args&... args) {
    out.debug(args...);
  }

  template <typename Entry>
  void emit(const Entry& e) {
    out.emit(e);
  }

 private:
  template <typename Tag>
  TrapLabel<Tag> allocateLabel() {
    return TrapLabel<Tag>::unsafeCreateFromExplicitId(id++);
  }
};

}  // namespace codeql
