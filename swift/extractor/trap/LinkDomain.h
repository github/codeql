#pragma once

#include <cassert>
#include "swift/extractor/infra/file/TargetFile.h"

namespace codeql {

class LinkDomain {
  TargetFile out;

  enum class Phase {
    header,
    target,
    objects,
    end,
  };

  Phase current{Phase::header};

 public:
  explicit LinkDomain(TargetFile out);

  void emitTarget(const std::string& target);
  void emitObjectDependency(const std::string& object);

 private:
  void ensurePhase(Phase phase);
};

}  // namespace codeql
