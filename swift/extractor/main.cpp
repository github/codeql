#include <stdlib.h>
#include <vector>
#include <iostream>
#include <regex>
#include <unistd.h>
#include <chrono>

#include <swift/Basic/LLVMInitialize.h>
#include <swift/DriverTool/DriverTool.h>
#include <swift/DriverTool/FrontendObserver.h>
#include <swift/Basic/InitializeSwiftModules.h>

#include "swift/extractor/SwiftExtractor.h"
#include "swift/extractor/infra/TargetDomains.h"
#include "swift/extractor/remapping/SwiftFileInterception.h"
#include "swift/extractor/invocation/SwiftDiagnosticsConsumer.h"
#include "swift/extractor/invocation/SwiftInvocationExtractor.h"
#include "swift/extractor/trap/TrapDomain.h"
#include "swift/extractor/infra/file/Path.h"

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

  void finished(int status) override {
    if (status != 0) return;
    codeql::SwiftLocationExtractor locExtractor{invocationTrap};
    for (const auto& src : state.sourceFiles) {
      auto fileLabel = locExtractor.emitFile(src);
      invocationTrap.emit(codeql::FileIsSuccessfullyExtractedTrap{fileLabel});
    }
  }

 private:
  codeql::SwiftExtractorState state;
  std::shared_ptr<codeql::FileInterceptor> openInterception{
      codeql::setupFileInterception(state.configuration)};
  codeql::TrapDomain invocationTrap{invocationTrapDomain(state)};
  codeql::SwiftDiagnosticsConsumer diagConsumer{invocationTrap};
};

static std::string getenv_or(const char* envvar, const std::string& def) {
  if (const char* var = getenv(envvar)) {
    return var;
  }
  return def;
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

codeql::SwiftExtractorConfiguration configure(llvm::ArrayRef<const char*> argv) {
  codeql::SwiftExtractorConfiguration configuration{};
  configuration.trapDir = getenv_or("CODEQL_EXTRACTOR_SWIFT_TRAP_DIR", ".");
  configuration.sourceArchiveDir = getenv_or("CODEQL_EXTRACTOR_SWIFT_SOURCE_ARCHIVE_DIR", ".");
  configuration.scratchDir = getenv_or("CODEQL_EXTRACTOR_SWIFT_SCRATCH_DIR", ".");
  configuration.frontendOptions.assign(argv.begin() + 1, argv.end());
  return configuration;
}

namespace swift {

FrontendObserver* getFrontendObserver(llvm::ArrayRef<const char*> argv) {
  static Observer observer{configure(argv)};
  return &observer;
}
}  // namespace swift
