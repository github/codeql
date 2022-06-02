#pragma once

#include <iostream>
#include <sstream>
#include <vector>

#include "swift/extractor/trap/TrapLabel.h"

namespace codeql {

// TrapArena has the responsibilities to allocate distinct trap #-labels
// TODO this is now a small functionality that will be moved to code upcoming from other PRs
class TrapArena {
  uint64_t id_{0};

 public:
  template <typename Tag>
  TrapLabel<Tag> allocateLabel() {
    return TrapLabel<Tag>::unsafeCreateFromExplicitId(id_++);
  }
};

}  // namespace codeql
