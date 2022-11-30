#include <fstream>
#include <iomanip>
#include <stdlib.h>
#include <vector>
#include <iostream>
#include <regex>
#include <unistd.h>
#include <chrono>

#include <swift/Basic/LLVMInitialize.h>
#include <swift/FrontendTool/FrontendTool.h>

#include "swift/extractor/SwiftExtractor.h"
#include "swift/extractor/TargetTrapFile.h"
#include "swift/extractor/remapping/SwiftOutputRewrite.h"
#include "swift/extractor/remapping/SwiftOpenInterception.h"
#include "swift/extractor/invocation/SwiftDiagnosticsConsumer.h"
#include "swift/extractor/SwiftInvocationExtractor.h"
#include "swift/extractor/trap/TrapDomain.h"

using namespace std::string_literals;

// This is part of the swiftFrontendTool interface, we hook into the
// compilation pipeline and extract files after the Swift frontend performed
// semantic analysis
class Observer : public swift::FrontendObserver {
 public:
  explicit Observer(const codeql::SwiftExtractorConfiguration& config,
                    codeql::SwiftExtractorState& state)
      : config{config}, state{state} {}

  void configuredCompiler(swift::CompilerInstance& instance) override {
    instance.addDiagnosticConsumer(&diagConsumer);
  }

  void performedSemanticAnalysis(swift::CompilerInstance& compiler) override {
    codeql::extractSwiftFiles(config, state, compiler);
    codeql::extractSwiftInvocation(config, state, compiler, invocationDomain);
  }

 private:
  // Creates a target file that should store per-invocation info, e.g. compilation args,
  // compilations, diagnostics, etc.
  codeql::TargetFile invocationTargetFile() {
    auto timestamp = std::chrono::system_clock::now().time_since_epoch().count();
    auto filename = std::to_string(timestamp) + '-' + std::to_string(getpid());
    auto target = std::filesystem::path("invocations") / std::filesystem::path(filename);
    auto maybeFile = codeql::createTargetTrapFile(config, state, target);
    if (!maybeFile) {
      std::cerr << "Cannot create invocation trap file: " << target << "\n";
      abort();
    }
    return std::move(maybeFile.value());
  }

  const codeql::SwiftExtractorConfiguration& config;
  codeql::SwiftExtractorState& state;

  codeql::TargetFile invocationTrapFile{invocationTargetFile()};
  codeql::TrapDomain invocationDomain{invocationTrapFile};
  codeql::SwiftDiagnosticsConsumer diagConsumer{invocationDomain};
};

static std::string getenv_or(const char* envvar, const std::string& def) {
  if (const char* var = getenv(envvar)) {
    return var;
  }
  return def;
}

static void lockOutputSwiftModuleTraps(const codeql::SwiftExtractorConfiguration& config,
                                       codeql::SwiftExtractorState& state,
                                       const codeql::PathRemapping& remapping) {
  for (const auto& [oldPath, newPath] : remapping) {
    if (oldPath.extension() == ".swiftmodule") {
      if (auto target = codeql::createTargetTrapFile(config, state, oldPath)) {
        *target << "// trap file deliberately empty\n"
                   "// this swiftmodule was created during the build, so its entities must have"
                   " been extracted directly from source files";
      }
    }
  }
}

static bool checkRunUnderFilter(int argc, char* const* argv) {
  auto runUnderFilter = getenv("CODEQL_EXTRACTOR_SWIFT_RUN_UNDER_FILTER");
  if (runUnderFilter == nullptr) {
    return true;
  }
  std::string call = argv[0];
  for (auto i = 1; i < argc; ++i) {
    call += ' ';
    call += argv[i];
  }
  std::regex filter{runUnderFilter, std::regex_constants::basic | std::regex_constants::nosubs};
  return std::regex_search(call, filter);
}

// if `CODEQL_EXTRACTOR_SWIFT_RUN_UNDER` env variable is set, and either
// * `CODEQL_EXTRACTOR_SWIFT_RUN_UNDER_FILTER` is not set, or
// * it is set to a regexp matching any substring of the extractor call
// then the running process is substituted with the command (and possibly
// options) stated in `CODEQL_EXTRACTOR_SWIFT_RUN_UNDER`, followed by `argv`.
// Before calling `exec`, `CODEQL_EXTRACTOR_SWIFT_RUN_UNDER` is unset to avoid
// unpleasant loops.
// An example usage is to run the extractor under `gdbserver :1234` when the
// arguments match a given source file.
static void checkWhetherToRunUnderTool(int argc, char* const* argv) {
  assert(argc > 0);

  auto runUnder = getenv("CODEQL_EXTRACTOR_SWIFT_RUN_UNDER");
  if (runUnder == nullptr || !checkRunUnderFilter(argc, argv)) {
    return;
  }
  std::vector<char*> args;
  // split RUN_UNDER value by spaces to get args vector
  for (auto word = std::strtok(runUnder, " "); word != nullptr; word = std::strtok(nullptr, " ")) {
    args.push_back(word);
  }
  // append process args, including extractor executable path
  args.insert(args.end(), argv, argv + argc);
  args.push_back(nullptr);
  // avoid looping on this function
  unsetenv("CODEQL_EXTRACTOR_SWIFT_RUN_UNDER");
  execvp(args[0], args.data());
}

int main(int argc, char** argv) {
  checkWhetherToRunUnderTool(argc, argv);

  if (argc == 1) {
    // TODO: print usage
    return 1;
  }

  // Required by Swift/LLVM
  PROGRAM_START(argc, argv);
  INITIALIZE_LLVM();

  codeql::SwiftExtractorConfiguration configuration{};
  codeql::SwiftExtractorState state{};
  configuration.trapDir = getenv_or("CODEQL_EXTRACTOR_SWIFT_TRAP_DIR", ".");
  configuration.sourceArchiveDir = getenv_or("CODEQL_EXTRACTOR_SWIFT_SOURCE_ARCHIVE_DIR", ".");
  configuration.scratchDir = getenv_or("CODEQL_EXTRACTOR_SWIFT_SCRATCH_DIR", ".");

  configuration.frontendOptions.reserve(argc - 1);
  for (int i = 1; i < argc; i++) {
    configuration.frontendOptions.push_back(argv[i]);
  }
  configuration.patchedFrontendOptions = configuration.frontendOptions;

  auto remapping = codeql::rewriteOutputsInPlace(configuration.getTempArtifactDir(),
                                                 configuration.patchedFrontendOptions);
  codeql::ensureDirectoriesForNewPathsExist(remapping);
  lockOutputSwiftModuleTraps(configuration, state, remapping);

  std::vector<const char*> args;
  for (auto& arg : configuration.patchedFrontendOptions) {
    args.push_back(arg.c_str());
  }

  Observer observer(configuration, state);
  int frontend_rc = swift::performFrontend(args, "swift-extractor", (void*)main, &observer);

  codeql::finalizeRemapping(remapping);

  return frontend_rc;
}
