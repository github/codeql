#include "SwiftExtractor.h"

#include <iostream>
#include <memory>
#include <unordered_set>
#include <queue>

#include <swift/AST/SourceFile.h>
#include <swift/Basic/FileTypes.h>
#include <llvm/ADT/SmallString.h>
#include <llvm/Support/FileSystem.h>
#include <llvm/Support/Path.h>

#include "swift/extractor/trap/generated/TrapClasses.h"
#include "swift/extractor/trap/TrapDomain.h"
#include "swift/extractor/visitors/SwiftVisitor.h"
#include "swift/extractor/infra/TargetFile.h"

using namespace codeql;

static void archiveFile(const SwiftExtractorConfiguration& config, swift::SourceFile& file) {
  if (std::error_code ec = llvm::sys::fs::create_directories(config.trapDir)) {
    std::cerr << "Cannot create TRAP directory: " << ec.message() << "\n";
    return;
  }

  if (std::error_code ec = llvm::sys::fs::create_directories(config.sourceArchiveDir)) {
    std::cerr << "Cannot create source archive directory: " << ec.message() << "\n";
    return;
  }

  llvm::SmallString<PATH_MAX> srcFilePath(file.getFilename());
  llvm::sys::fs::make_absolute(srcFilePath);

  llvm::SmallString<PATH_MAX> dstFilePath(config.sourceArchiveDir);
  llvm::sys::path::append(dstFilePath, srcFilePath);

  llvm::StringRef parent = llvm::sys::path::parent_path(dstFilePath);
  if (std::error_code ec = llvm::sys::fs::create_directories(parent)) {
    std::cerr << "Cannot create source archive destination directory '" << parent.str()
              << "': " << ec.message() << "\n";
    return;
  }

  if (std::error_code ec = llvm::sys::fs::copy_file(srcFilePath, dstFilePath)) {
    std::cerr << "Cannot archive source file '" << srcFilePath.str().str() << "' -> '"
              << dstFilePath.str().str() << "': " << ec.message() << "\n";
    return;
  }
}

static std::string getFilename(swift::ModuleDecl& module, swift::SourceFile* primaryFile) {
  if (primaryFile) {
    return primaryFile->getFilename().str();
  }
  // Several modules with different name might come from .pcm (clang module) files
  // In this case we want to differentiate them
  std::string filename = module.getModuleFilename().str();
  filename += "-";
  filename += module.getName().str();
  return filename;
}

static llvm::SmallVector<swift::Decl*> getTopLevelDecls(swift::ModuleDecl& module,
                                                        swift::SourceFile* primaryFile = nullptr) {
  llvm::SmallVector<swift::Decl*> ret;
  ret.push_back(&module);
  if (primaryFile) {
    primaryFile->getTopLevelDecls(ret);
  } else {
    module.getTopLevelDecls(ret);
  }
  return ret;
}

static void dumpArgs(TargetFile& out, const SwiftExtractorConfiguration& config) {
  out << "/* extractor-args:\n";
  for (const auto& opt : config.frontendOptions) {
    out << "  " << std::quoted(opt) << " \\\n";
  }
  out << "\n*/\n";

  out << "/* swift-frontend-args:\n";
  for (const auto& opt : config.patchedFrontendOptions) {
    out << "  " << std::quoted(opt) << " \\\n";
  }
  out << "\n*/\n";
}

static void extractDeclarations(const SwiftExtractorConfiguration& config,
                                swift::CompilerInstance& compiler,
                                swift::ModuleDecl& module,
                                swift::SourceFile* primaryFile = nullptr) {
  auto filename = getFilename(module, primaryFile);

  // The extractor can be called several times from different processes with
  // the same input file(s). Using `TargetFile` the first process will win, and the following
  // will just skip the work
  auto trapTarget = TargetFile::create(filename + ".trap", config.trapDir, config.getTempTrapDir());
  if (!trapTarget) {
    // another process arrived first, nothing to do for us
    return;
  }
  dumpArgs(*trapTarget, config);
  TrapDomain trap{*trapTarget};

  // TODO: remove this and recreate it with IPA when we have that
  // the following cannot conflict with actual files as those have an absolute path starting with /
  File unknownFileEntry{trap.createLabel<FileTag>("unknown")};
  Location unknownLocationEntry{trap.createLabel<LocationTag>("unknown")};
  unknownLocationEntry.file = unknownFileEntry.id;
  trap.emit(unknownFileEntry);
  trap.emit(unknownLocationEntry);

  SwiftVisitor visitor(compiler.getSourceMgr(), trap, module, primaryFile);
  auto topLevelDecls = getTopLevelDecls(module, primaryFile);
  for (auto decl : topLevelDecls) {
    visitor.extract(decl);
  }
}

static std::unordered_set<std::string> collectInputFilenames(swift::CompilerInstance& compiler) {
  // The frontend can be called in many different ways.
  // At each invocation we only extract system and builtin modules and any input source files that
  // have an output associated with them.
  std::unordered_set<std::string> sourceFiles;
  auto inputFiles = compiler.getInvocation().getFrontendOptions().InputsAndOutputs.getAllInputs();
  for (auto& input : inputFiles) {
    if (input.getType() == swift::file_types::TY_Swift && !input.outputFilename().empty()) {
      sourceFiles.insert(input.getFileName());
    }
  }
  return sourceFiles;
}

static std::unordered_set<swift::ModuleDecl*> collectModules(swift::CompilerInstance& compiler) {
  // getASTContext().getLoadedModules() does not provide all the modules available within the
  // program.
  // We need to iterate over all the imported modules (recursively) to see the whole "universe."
  std::unordered_set<swift::ModuleDecl*> allModules;
  std::queue<swift::ModuleDecl*> worklist;
  for (auto& [_, module] : compiler.getASTContext().getLoadedModules()) {
    worklist.push(module);
    allModules.insert(module);
  }

  while (!worklist.empty()) {
    auto module = worklist.front();
    worklist.pop();
    llvm::SmallVector<swift::ImportedModule> importedModules;
    // TODO: we may need more than just Exported ones
    module->getImportedModules(importedModules, swift::ModuleDecl::ImportFilterKind::Exported);
    for (auto& imported : importedModules) {
      if (allModules.count(imported.importedModule) == 0) {
        worklist.push(imported.importedModule);
        allModules.insert(imported.importedModule);
      }
    }
  }
  return allModules;
}

void codeql::extractSwiftFiles(const SwiftExtractorConfiguration& config,
                               swift::CompilerInstance& compiler) {
  auto inputFiles = collectInputFilenames(compiler);
  auto modules = collectModules(compiler);

  // we want to make sure any following extractor run will not try to extract things from
  // the swiftmodule files we are creating in this run, as those things will already have been
  // extracted from source with more information. We do this by creating empty trap files.
  // TargetFile semantics will ensure any following run trying to extract that swiftmodule will just
  // skip doing it
  auto outputModuleTrapSuffix = "-" + compiler.getMainModule()->getName().str().str() + ".trap";
  for (const auto& output : config.outputSwiftModules) {
    TargetFile::create(output + outputModuleTrapSuffix, config.trapDir, config.getTempTrapDir());
  }
  for (auto& module : modules) {
    bool isFromSourceFile = false;
    for (auto file : module->getFiles()) {
      auto sourceFile = llvm::dyn_cast<swift::SourceFile>(file);
      if (!sourceFile) {
        continue;
      }
      isFromSourceFile = true;
      if (inputFiles.count(sourceFile->getFilename().str()) == 0) {
        continue;
      }
      archiveFile(config, *sourceFile);
      extractDeclarations(config, compiler, *module, sourceFile);
    }
    if (!isFromSourceFile) {
      extractDeclarations(config, compiler, *module);
    }
  }
}
