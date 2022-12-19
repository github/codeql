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
  oss << "\nmodules:";
  std::vector<const swift::ModuleDecl*> modules{state.encounteredModules.begin(),
                                                state.encounteredModules.end()};
  std::sort(modules.begin(), modules.end(),
            [](auto lhs, auto rhs) { return lhs->getRealName().str() < rhs->getRealName().str(); });
  for (auto module : modules) {
    oss << "\n  " << std::string_view{module->getRealName().str()};
  }
  trap.debug(oss.str());
}
}  // namespace codeql
