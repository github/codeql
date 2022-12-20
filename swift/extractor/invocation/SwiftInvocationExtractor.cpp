#include "swift/extractor/invocation/SwiftInvocationExtractor.h"
#include "swift/extractor/remapping/SwiftFileInterception.h"
#include "swift/extractor/infra/file/FileHash.h"
#include "swift/extractor/infra/TargetTrapDomain.h"
#include "swift/extractor/trap/generated/TrapTags.h"
#include "swift/extractor/infra/file/TargetFile.h"
#include "swift/extractor/infra/file/Path.h"

namespace fs = std::filesystem;
namespace codeql {
void extractSwiftInvocation(SwiftExtractorState& state,
                            swift::CompilerInstance& compiler,
                            TrapDomain& trap) {
  std::vector<std::tuple<fs::path, std::string>> targets;
  targets.reserve(state.originalOutputModules.size());
  // notice that there is only one unique module name per frontend run, even when outputting
  // multiples `swiftmodule` files
  const auto& moduleName = compiler.getInvocation().getFrontendOptions().ModuleName;
  for (const auto& modulePath : state.originalOutputModules) {
    if (auto fd = openReal(modulePath); fd >= 0) {
      if (auto hash = hashFile(fd); !hash.empty()) {
        fs::path target{"linkage-awareness"};
        target /= "modules";
        target /= moduleName;
        target += '_';
        target += hash;
        target /= "module";
        if (auto moduleTrap = createTargetTrapDomain(state, target)) {
          moduleTrap->createLabelWithImplementationId<ModuleDeclTag>(hash, moduleName);
          targets.emplace_back(std::move(target), std::move(hash));
        }
      }
    }
  }
  for (const auto& input : state.primaryFiles) {
    auto path = resolvePath(input);
    fs::path target{"linkage-awareness/inputs"};
    target /= path.relative_path();
    target += ".odep";
    if (auto targetFile = TargetFile::create(target, state.configuration.trapDir,
                                             state.configuration.getTempTrapDir())) {
      *targetFile << "TRAP dependencies 1.2\n"
                  << "OBJECTS\n"
                  << "input:" << path.c_str() << '\n'
                  << "INPUT_OBJECTS\n";
      for (auto encounteredModule : state.encounteredModules) {
        if (auto fd = openReal(std::string_view{encounteredModule->getModuleFilename()}); fd >= 0) {
          if (auto depHash = hashFile(fd); !depHash.empty()) {
            *targetFile << "module:" << std::string_view{encounteredModule->getRealName().str()}
                        << ':' << depHash << '\n';
          }
        }
      }
      *targetFile << "TRAPS\n";
      for (const auto& requestedTrap : state.traps) {
        *targetFile << requestedTrap.c_str() << '\n';
      }
    }
    target.replace_extension(".link");
    std::ofstream{state.configuration.trapDir / target} << "Linker invocation 1.0\n"
                                                        << "TARGET\n"
                                                        << "input:" << path.c_str() << '\n'
                                                        << "OBJECTS\n"
                                                        << "input:" << path.c_str() << '\n';
  }
  for (const auto& [target, hash] : targets) {
    auto linkFile = target;
    linkFile += ".link";
    std::ofstream{state.configuration.trapDir / linkFile}
        << "Linker invocation 1.0\n"
        << "TARGET\n"
        << "module:" << moduleName << ':' << hash << '\n'
        << "OBJECTS\n"
        << "module:" << moduleName << ':' << hash << '\n';
    auto odepFile = target;
    odepFile += ".odep";
    std::ofstream odep{state.configuration.trapDir / odepFile};
    odep << "TRAP dependencies 1.2\n"
         << "OBJECTS\n"
         << "module:" << moduleName << ':' << hash << '\n'
         << "INPUT_OBJECTS\n";
    for (auto encounteredModule : state.encounteredModules) {
      if (auto fd = openReal(std::string_view{encounteredModule->getModuleFilename()}); fd >= 0) {
        if (auto depHash = hashFile(fd); !depHash.empty()) {
          odep << "module:" << std::string_view{encounteredModule->getRealName().str()} << ':'
               << depHash << '\n';
        }
      }
    }
    if (compiler.getInvocation().getFrontendOptions().RequestedAction !=
        swift::FrontendOptions::ActionType::MergeModules) {
      for (const auto& input :
           compiler.getInvocation().getFrontendOptions().InputsAndOutputs.getAllInputs()) {
        odep << "input:" << resolvePath(input.getFileName()).c_str() << '\n';
      }
    } else {
      for (const auto& input :
           compiler.getInvocation().getFrontendOptions().InputsAndOutputs.getAllInputs()) {
        if (auto fd = openReal(input.getFileName()); fd >= 0) {
          if (auto mergedHash = hashFile(fd); !mergedHash.empty()) {
            odep << "module:" << moduleName << ':' << mergedHash << '\n';
            auto mergedModuleLink = state.configuration.trapDir;
            mergedModuleLink /= "linkage-awareness";
            mergedModuleLink /= "modules";
            mergedModuleLink /= moduleName;
            mergedModuleLink += '_';
            mergedModuleLink += mergedHash;
            mergedModuleLink /= "module.link";
            fs::remove(mergedModuleLink);
            fs::remove(mergedModuleLink.replace_extension(".trap"));
          }
        }
      }
    }
    odep << "TRAPS\n";
    for (const auto& requestedTrap : state.traps) {
      odep << requestedTrap.c_str() << '\n';
    }
  }
}
}  // namespace codeql
