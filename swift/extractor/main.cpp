#include <fstream>
#include <iomanip>
#include <stdlib.h>
#include <unordered_set>
#include <vector>
#include <string>
#include <iostream>

#include <swift/Basic/LLVMInitialize.h>
#include <swift/FrontendTool/FrontendTool.h>

#include "swift/extractor/SwiftExtractor.h"
#include "swift/extractor/TargetTrapFile.h"
#include "swift/extractor/remapping/SwiftOutputRewrite.h"
#include "swift/extractor/remapping/SwiftOpenInterception.h"

using namespace std::string_literals;

// This is part of the swiftFrontendTool interface, we hook into the
// compilation pipeline and extract files after the Swift frontend performed
// semantic analysis
class Observer : public swift::FrontendObserver {
 public:
  explicit Observer(const codeql::SwiftExtractorConfiguration& config) : config{config} {}

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

static void lockOutputSwiftModuleTraps(const codeql::SwiftExtractorConfiguration& config,
                                       const codeql::PathRemapping& remapping) {
  for (const auto& [oldPath, newPath] : remapping) {
    if (oldPath.extension() == ".swiftmodule") {
      if (auto target = codeql::createTargetTrapFile(config, oldPath)) {
        *target << "// trap file deliberately empty\n"
                   "// this swiftmodule was created during the build, so its entities must have"
                   " been extracted directly from source files";
      }
    }
  }
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
  configuration.scratchDir = getenv_or("CODEQL_EXTRACTOR_SWIFT_SCRATCH_DIR", ".");

  codeql::initRemapping(configuration.getTempArtifactDir());

  configuration.frontendOptions.reserve(argc - 1);
  for (int i = 1; i < argc; i++) {
    configuration.frontendOptions.push_back(argv[i]);
  }
  configuration.patchedFrontendOptions = configuration.frontendOptions;

  auto remapping = codeql::rewriteOutputsInPlace(configuration.getTempArtifactDir(),
                                                 configuration.patchedFrontendOptions);
  codeql::ensureDirectoriesForNewPathsExist(remapping);
  lockOutputSwiftModuleTraps(configuration, remapping);

  std::vector<const char*> args;
  for (auto& arg : configuration.patchedFrontendOptions) {
    args.push_back(arg.c_str());
  }

  Observer observer(configuration);
  int frontend_rc = swift::performFrontend(args, "swift-extractor", (void*)main, &observer);

  codeql::finalizeRemapping(remapping);

  return frontend_rc;
}
