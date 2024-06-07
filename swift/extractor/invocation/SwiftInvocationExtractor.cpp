#include "swift/extractor/invocation/SwiftInvocationExtractor.h"
#include "swift/extractor/remapping/SwiftFileInterception.h"
#include "swift/extractor/infra/TargetDomains.h"
#include "swift/extractor/trap/generated/TrapTags.h"
#include "swift/extractor/infra/file/TargetFile.h"
#include "swift/extractor/infra/file/Path.h"
#include "swift/logging/SwiftAssert.h"
#include "swift/extractor/mangler/SwiftMangler.h"

namespace fs = std::filesystem;
using namespace std::string_literals;

namespace codeql {
namespace {

Logger& logger() {
  static Logger ret{"invocation"};
  return ret;
}

std::string getModuleId(const std::string_view& name, const std::string_view& hash) {
  auto ret = "module:"s;
  ret += name;
  ret += ':';
  ret += hash;
  return ret;
}

std::string getModuleId(const swift::ModuleDecl* module, const std::string_view& hash) {
  return getModuleId(module->getRealName().str(), hash);
}

fs::path getModuleTarget(const std::string_view& name, const std::string_view& hash) {
  fs::path ret{"modules"};
  ret /= name;
  ret += '_';
  ret += hash;
  ret /= "module";
  return ret;
}

std::optional<std::string> getModuleHash(const fs::path& moduleFile) {
  return getHashOfRealFile(moduleFile);
}

std::optional<std::string> getModuleHash(const swift::ModuleDecl* module) {
  return getModuleHash(std::string_view{module->getModuleFilename()});
}

std::string getSourceId(const fs::path& file) {
  return "source:"s + file.c_str();
}

std::string getSourceId(const swift::InputFile& input) {
  return getSourceId(resolvePath(input.getFileName()));
}

fs::path getSourceTarget(const fs::path& file) {
  return "sources" / file.relative_path();
}

struct ModuleInfo {
  fs::path target;
  std::string id;
};

std::vector<ModuleInfo> emitModuleImplementations(SwiftExtractorState& state,
                                                  const std::string& moduleName) {
  std::vector<ModuleInfo> ret;
  ret.reserve(state.originalOutputModules.size());
  for (const auto& modulePath : state.originalOutputModules) {
    if (auto hash = getModuleHash(modulePath)) {
      auto target = getModuleTarget(moduleName, *hash);
      if (auto moduleTrap = createTargetTrapDomain(state, target, TrapType::linkage)) {
        moduleTrap->createTypedLabelWithImplementationId<ModuleDeclTag>(
            SwiftMangler::mangleModuleName(moduleName), *hash);
        ret.push_back({target, getModuleId(moduleName, *hash)});
      }
    }
  }
  return ret;
}

void emitLinkFile(const SwiftExtractorState& state, const fs::path& target, const std::string& id) {
  if (auto link = createTargetLinkDomain(state, target)) {
    link->emitTarget(id);
    link->emitObjectDependency(id);
  }
}

void emitSourceObjectDependencies(const SwiftExtractorState& state,
                                  const fs::path& target,
                                  const std::string& id) {
  if (auto object = createTargetObjectDomain(state, target)) {
    object->emitObject(id);
    for (auto encounteredModule : state.encounteredModules) {
      if (auto depHash = getModuleHash(encounteredModule)) {
        auto encounteredModuleId = getModuleId(encounteredModule, *depHash);
        if (encounteredModuleId != id) {
          object->emitObjectDependency(encounteredModuleId);
        }
      }
    }
    for (const auto& requestedTrap : state.traps) {
      object->emitTrapDependency(requestedTrap);
    }
  }
}

void replaceMergedModulesImplementation(const SwiftExtractorState& state,
                                        const std::string& name,
                                        const fs::path& mergeTarget,
                                        const std::string& mergedPartHash) {
  std::error_code ec;
  auto mergedPartTarget = getModuleTarget(name, mergedPartHash);
  fs::copy(getTrapPath(state, mergeTarget, TrapType::linkage),
           getTrapPath(state, mergedPartTarget, TrapType::linkage),
           fs::copy_options::overwrite_existing, ec);
  CODEQL_ASSERT(!ec, "Unable to replace trap implementation id for merged module '{}' ({})", name,
                ec);
}

void emitModuleObjectDependencies(const SwiftExtractorState& state,
                                  const swift::FrontendOptions& options,
                                  const fs::path& target,
                                  const std::string& id) {
  if (auto object = createTargetObjectDomain(state, target)) {
    object->emitObject(id);
    for (auto encounteredModule : state.encounteredModules) {
      if (auto depHash = getModuleHash(encounteredModule)) {
        object->emitObjectDependency(getModuleId(encounteredModule, *depHash));
      }
    }
    if (options.RequestedAction == swift::FrontendOptions::ActionType::MergeModules) {
      for (const auto& input : options.InputsAndOutputs.getAllInputs()) {
        if (auto mergedHash = getModuleHash(input.getFileName())) {
          object->emitObjectDependency(getModuleId(options.ModuleName, *mergedHash));
          replaceMergedModulesImplementation(state, options.ModuleName, target, *mergedHash);
        }
      }
    } else {
      for (const auto& input : options.InputsAndOutputs.getAllInputs()) {
        object->emitObjectDependency(getSourceId(input));
      }
    }
    for (const auto& requestedTrap : state.traps) {
      object->emitTrapDependency(requestedTrap);
    }
  }
}
}  // namespace

void extractSwiftInvocation(SwiftExtractorState& state,
                            swift::CompilerInstance& compiler,
                            TrapDomain& trap) {
  const auto& options = compiler.getInvocation().getFrontendOptions();

  // notice that there is only one unique module name per frontend run, even when outputting
  // multiples `swiftmodule` files
  // this step must be executed first so that we can capture in `state` the emitted trap files
  // that will be used in following steps
  auto modules = emitModuleImplementations(state, options.ModuleName);

  for (const auto& input : state.sourceFiles) {
    auto path = resolvePath(input);
    auto target = getSourceTarget(path);
    auto inputId = getSourceId(path);
    emitSourceObjectDependencies(state, target, inputId);
  }

  for (const auto& [target, moduleId] : modules) {
    emitLinkFile(state, target, moduleId);
    emitModuleObjectDependencies(state, options, target, moduleId);
  }
}
}  // namespace codeql
