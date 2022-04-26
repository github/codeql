#include <fstream>
#include <iomanip>
#include <stdlib.h>

#include <swift/Basic/LLVMInitialize.h>
#include <swift/FrontendTool/FrontendTool.h>

#include "Extractor.h"

using namespace std::string_literals;

class Observer : public swift::FrontendObserver {
 public:
  explicit Observer(const codeql::Configuration& config) : config{config} {}

  void performedSemanticAnalysis(swift::CompilerInstance& instance) override {
    codeql::Extractor extractor(config, instance);
    extractor.extract();
  }

 private:
  const codeql::Configuration& config;
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

  codeql::Configuration configuration{};
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
