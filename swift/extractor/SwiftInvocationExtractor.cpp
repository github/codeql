#include "swift/extractor/SwiftInvocationExtractor.h"

namespace codeql {
void extractSwiftInvocation(const SwiftExtractorConfiguration& config,
                            SwiftExtractorState& state,
                            swift::CompilerInstance& compiler,
                            TrapDomain& domain) {
  std::ostringstream oss;
  oss << "TRAPS:";
  for (const auto& trap : state.trapFiles) {
    oss << "\n  " << trap;
  }
  oss << "\n\nMODULES:";
  for (auto m : state.encounteredModules) {
    oss << "\n  " << m->getRealName().str().str();
  }
  domain.debug(oss.str());
}
}  // namespace codeql
