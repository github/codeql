#include "swift/extractor/trap/LinkDomain.h"

namespace codeql {
LinkDomain::LinkDomain(TargetFile out) : out{std::move(out)} {
  this->out << "Linker invocation 1.0\n";
}

void LinkDomain::emitTarget(const std::string& target) {
  ensurePhase(Phase::target);
  out << target << '\n';
}

void LinkDomain::emitObjectDependency(const std::string& object) {
  ensurePhase(Phase::objects);
  out << object << '\n';
}

void LinkDomain::ensurePhase(Phase phase) {
  assert(phase >= current && "wrong order in .link file attributes");

  if (phase > current) {
    switch (phase) {
      case Phase::target:
        out << "TARGET\n";
        break;
      case Phase::objects:
        out << "OBJECTS\n";
        break;
      default:
        assert(false && "unexpected phase");
        break;
    }
  }
  current = phase;
}

}  // namespace codeql
