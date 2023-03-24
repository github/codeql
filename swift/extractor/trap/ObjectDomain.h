#pragma once

#include <cassert>
#include <filesystem>
#include "swift/extractor/infra/file/TargetFile.h"

namespace codeql {

class ObjectDomain {
  TargetFile out;

  enum class Phase {
    header,
    objects,
    input_objects,
    traps,
    end,
  };

  Phase current{Phase::header};

 public:
  explicit ObjectDomain(TargetFile out);

  void emitObject(const std::string& object);
  void emitObjectDependency(const std::string& object);
  void emitTrapDependency(const std::filesystem::path& trap);

 private:
  void ensurePhase(Phase phase);
};

}  // namespace codeql
