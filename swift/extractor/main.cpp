#include <fstream>
#include <iomanip>
#include <stdlib.h>

#include <swift/Basic/LLVMInitialize.h>
#include <swift/FrontendTool/FrontendTool.h>

#include "SwiftExtractor.h"

using namespace std::string_literals;

// This is part of the swiftFrontendTool interface, we hook into the
// compilation pipeline and extract files after the Swift frontend performed
// semantic analysys
class Observer : public swift::FrontendObserver {
 public:
  explicit Observer(const codeql::SwiftExtractorConfiguration& config) : config{config} {}

  void parsedArgs(swift::CompilerInvocation& invocation) override {
    // Original compiler and the extractor-compiler get into conflicts when
    // both produce the same output files.
    // TODO: change the final artifact destinations instead of disabling
    // the artifact generation completely?
    invocation.getFrontendOptions().RequestedAction = swift::FrontendOptions::ActionType::Typecheck;
  }

  void performedSemanticAnalysis(swift::CompilerInstance& compiler) override {
    codeql::extractSwiftFiles(config, compiler);
  }

 private:
  const codeql::SwiftExtractorConfiguration& config;
};

static std::string getenv_or(const char* envvar, const std::string& def) {
  if (const char* var = getenv(envvar)) {
    return var;
  }
  return def;
}

int main(int argc, char** argv) {
  if (argc == 1) {
    // TODO: print usage
    return 1;
  }
  // Required by Swift/LLVM
  PROGRAM_START(argc, argv);
  INITIALIZE_LLVM();

  codeql::SwiftExtractorConfiguration configuration{};
  configuration.trapDir = getenv_or("CODEQL_EXTRACTOR_SWIFT_TRAP_DIR", ".");
  configuration.sourceArchiveDir = getenv_or("CODEQL_EXTRACTOR_SWIFT_SOURCE_ARCHIVE_DIR", ".");
  std::vector<const char*> args;
  for (int i = 1; i < argc; i++) {
    args.push_back(argv[i]);
  }
  std::copy(std::begin(args), std::end(args), std::back_inserter(configuration.frontendOptions));
  Observer observer(configuration);
  int frontend_rc = swift::performFrontend(args, "swift-extractor", (void*)main, &observer);
  return frontend_rc;
}
