#include "swift/extractor/invocation/SwiftInvocationExtractor.h"

namespace codeql {
void extractSwiftInvocation(const SwiftExtractorState& state,
                            swift::CompilerInstance& compiler,
                            TrapDomain& trap) {
  std::ostringstream oss;
  oss << "TRAP files:";
  for (const auto& trapFile : state.traps) {
    oss << "\n  " << trapFile.c_str();
  }
  trap.debug(oss.str());
}
}  // namespace codeql
