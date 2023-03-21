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
#include <swift/Basic/InitializeSwiftModules.h>

#include "swift/extractor/SwiftExtractor.h"
#include "swift/extractor/infra/TargetDomains.h"
#include "swift/extractor/remapping/SwiftFileInterception.h"
#include "swift/extractor/invocation/SwiftDiagnosticsConsumer.h"
#include "swift/extractor/invocation/SwiftInvocationExtractor.h"
#include "swift/extractor/trap/TrapDomain.h"
#include "swift/extractor/infra/file/Path.h"
#include <swift/Basic/InitializeSwiftModules.h>

using namespace std::string_literals;

// must be called before processFrontendOptions modifies output paths
static void lockOutputSwiftModuleTraps(codeql::SwiftExtractorState& state,
                                       const swift::FrontendOptions& options) {
  for (const auto& input : options.InputsAndOutputs.getAllInputs()) {
    if (const auto& module = input.getPrimarySpecificPaths().SupplementaryOutputs.ModuleOutputPath;
        !module.empty()) {
      if (auto target = codeql::createTargetTrapDomain(state, codeql::resolvePath(module),
                                                       codeql::TrapType::module)) {
        target->emit("// trap file deliberately empty\n"
                     "// this swiftmodule was created during the build, so its entities must have"
                     " been extracted directly from source files");
      }
    }
  }
}

static void processFrontendOptions(codeql::SwiftExtractorState& state,
                                   swift::FrontendOptions& options) {
  auto& inOuts = options.InputsAndOutputs;
  std::vector<swift::InputFile> inputs;
  inOuts.forEachInput([&](const swift::InputFile& input) {
    std::cerr << input.getFileName() << ":\n";
    swift::PrimarySpecificPaths psp{};
    if (std::filesystem::path output = input.getPrimarySpecificPaths().OutputFilename;
        !output.empty()) {
      if (output.extension() == ".swiftmodule") {
        psp.OutputFilename = codeql::redirect(output);
      } else {
        psp.OutputFilename = "/dev/null";
      }
    }
    if (std::filesystem::path module =
            input.getPrimarySpecificPaths().SupplementaryOutputs.ModuleOutputPath;
        !module.empty()) {
      psp.SupplementaryOutputs.ModuleOutputPath = codeql::redirect(module);
      state.originalOutputModules.push_back(module);
    }
    auto inputCopy = input;
    inputCopy.setPrimarySpecificPaths(std::move(psp));
    inputs.push_back(std::move(inputCopy));
    return false;
  });
  inOuts.clearInputs();
  for (const auto& i : inputs) {
    inOuts.addInput(i);
  }
}

codeql::TrapDomain invocationTrapDomain(codeql::SwiftExtractorState& state);

// This is part of the swiftFrontendTool interface, we hook into the
// compilation pipeline and extract files after the Swift frontend performed
// semantic analysis
class Observer : public swift::FrontendObserver {
 public:
  explicit Observer(const codeql::SwiftExtractorConfiguration& config) : state{config} {}

  void parsedArgs(swift::CompilerInvocation& invocation) override {
    auto& options = invocation.getFrontendOptions();
    lockOutputSwiftModuleTraps(state, options);
    processFrontendOptions(state, options);
  }

  void configuredCompiler(swift::CompilerInstance& instance) override {
    instance.addDiagnosticConsumer(&diagConsumer);
  }

  void performedSemanticAnalysis(swift::CompilerInstance& compiler) override {
    codeql::extractSwiftFiles(state, compiler);
    codeql::extractSwiftInvocation(state, compiler, invocationTrap);
    codeql::extractExtractLazyDeclarations(state, compiler);
  }

  void markSuccessfullyExtractedFiles() {
    codeql::SwiftLocationExtractor locExtractor{invocationTrap};
    for (const auto& src : state.sourceFiles) {
      auto fileLabel = locExtractor.emitFile(src);
      invocationTrap.emit(codeql::FileIsSuccessfullyExtractedTrap{fileLabel});
    }
  }

 private:
  codeql::SwiftExtractorState state;
  codeql::TrapDomain invocationTrap{invocationTrapDomain(state)};
  codeql::SwiftDiagnosticsConsumer diagConsumer{invocationTrap};
};

static std::string getenv_or(const char* envvar, const std::string& def) {
  if (const char* var = getenv(envvar)) {
    return var;
  }
  return def;
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

// Creates a target file that should store per-invocation info, e.g. compilation args,
// compilations, diagnostics, etc.
codeql::TrapDomain invocationTrapDomain(codeql::SwiftExtractorState& state) {
  auto timestamp = std::chrono::system_clock::now().time_since_epoch().count();
  auto filename = std::to_string(timestamp) + '-' + std::to_string(getpid());
  auto target = std::filesystem::path("invocations") / std::filesystem::path(filename);
  auto maybeDomain = codeql::createTargetTrapDomain(state, target, codeql::TrapType::invocation);
  if (!maybeDomain) {
    std::cerr << "Cannot create invocation trap file: " << target << "\n";
    abort();
  }
  return std::move(maybeDomain.value());
}

codeql::SwiftExtractorConfiguration configure(int argc, char** argv) {
  codeql::SwiftExtractorConfiguration configuration{};
  configuration.trapDir = getenv_or("CODEQL_EXTRACTOR_SWIFT_TRAP_DIR", ".");
  configuration.sourceArchiveDir = getenv_or("CODEQL_EXTRACTOR_SWIFT_SOURCE_ARCHIVE_DIR", ".");
  configuration.scratchDir = getenv_or("CODEQL_EXTRACTOR_SWIFT_SCRATCH_DIR", ".");
  configuration.frontendOptions.assign(argv + 1, argv + argc);
  return configuration;
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
  initializeSwiftModules();

  const auto configuration = configure(argc, argv);

  auto openInterception = codeql::setupFileInterception(configuration);

  Observer observer(configuration);
  int frontend_rc = swift::performFrontend(configuration.frontendOptions, "swift-extractor",
                                           (void*)main, &observer);

  if (frontend_rc == 0) {
    observer.markSuccessfullyExtractedFiles();
  }

  return frontend_rc;
}
