#include "swift/extractor/trap/ObjectDomain.h"

namespace codeql {
ObjectDomain::ObjectDomain(TargetFile out) : out{std::move(out)} {
  this->out << "TRAP dependencies 1.2\n";
}

void ObjectDomain::emitObject(const std::string& object) {
  ensurePhase(Phase::objects);
  out << object << '\n';
}

void ObjectDomain::emitObjectDependency(const std::string& object) {
  ensurePhase(Phase::input_objects);
  out << object << '\n';
}

void ObjectDomain::emitTrapDependency(const std::filesystem::path& trap) {
  ensurePhase(Phase::traps);
  out << trap.c_str() << '\n';
}

void ObjectDomain::ensurePhase(Phase phase) {
  assert(phase >= current && "wrong order in .odep file attributes");

  if (phase > current) {
    switch (phase) {
      case Phase::objects:
        out << "OBJECTS\n";
        break;
      case Phase::input_objects:
        out << "INPUT_OBJECTS\n";
        break;
      case Phase::traps:
        out << "TRAPS\n";
        break;
      default:
        assert(false && "unexpected phase");
        break;
    }
  }
  current = phase;
}

}  // namespace codeql
