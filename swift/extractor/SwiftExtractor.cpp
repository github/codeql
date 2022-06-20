#include "SwiftExtractor.h"

#include <filesystem>
#include <fstream>
#include <iostream>
#include <sstream>
#include <memory>
#include <unistd.h>
#include <unordered_set>

#include <swift/AST/SourceFile.h>
#include <swift/Basic/FileTypes.h>
#include <llvm/ADT/SmallString.h>
#include <llvm/Support/FileSystem.h>
#include <llvm/Support/Path.h>

#include "swift/extractor/trap/generated/TrapClasses.h"
#include "swift/extractor/trap/TrapOutput.h"
#include "swift/extractor/SwiftVisitor.h"

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

static void extractDeclarations(const SwiftExtractorConfiguration& config,
                                llvm::ArrayRef<swift::Decl*> topLevelDecls,
                                swift::CompilerInstance& compiler,
                                swift::ModuleDecl& module,
                                swift::SourceFile* primaryFile = nullptr) {
  // The extractor can be called several times from different processes with
  // the same input file(s)
  // We are using PID to avoid concurrent access
  // TODO: find a more robust approach to avoid collisions?
  llvm::StringRef filename = primaryFile ? primaryFile->getFilename() : module.getModuleFilename();
  std::string tempTrapName = filename.str() + '.' + std::to_string(getpid()) + ".trap";
  llvm::SmallString<PATH_MAX> tempTrapPath(config.trapDir);
  llvm::sys::path::append(tempTrapPath, tempTrapName);

  llvm::StringRef trapParent = llvm::sys::path::parent_path(tempTrapPath);
  if (std::error_code ec = llvm::sys::fs::create_directories(trapParent)) {
    std::cerr << "Cannot create trap directory '" << trapParent.str() << "': " << ec.message()
              << "\n";
    return;
  }

  std::ofstream trapStream(tempTrapPath.str().str());
  if (!trapStream) {
    std::error_code ec;
    ec.assign(errno, std::generic_category());
    std::cerr << "Cannot create temp trap file '" << tempTrapPath.str().str()
              << "': " << ec.message() << "\n";
    return;
  }
  trapStream << "// extractor-args: ";
  for (auto opt : config.frontendOptions) {
    trapStream << std::quoted(opt) << " ";
  }
  trapStream << "\n\n";

  TrapOutput trap{trapStream};
  TrapArena arena{};

  // TODO: move default location emission elsewhere, possibly in a separate global trap file
  auto unknownFileLabel = arena.allocateLabel<FileTag>();
  // the following cannot conflict with actual files as those have an absolute path starting with /
  trap.assignKey(unknownFileLabel, "unknown");
  trap.emit(FilesTrap{unknownFileLabel});
  auto unknownLocationLabel = arena.allocateLabel<LocationTag>();
  trap.assignKey(unknownLocationLabel, "unknown");
  trap.emit(LocationsTrap{unknownLocationLabel, unknownFileLabel});

  SwiftVisitor visitor(compiler.getSourceMgr(), arena, trap, module, primaryFile);
  for (auto decl : topLevelDecls) {
    visitor.extract(decl);
  }
  if (topLevelDecls.empty()) {
    // In the case of empty files, the dispatcher is not called, but we still want to 'record' the
    // fact that the file was extracted
    llvm::SmallString<PATH_MAX> name(filename);
    llvm::sys::fs::make_absolute(name);
    auto fileLabel = arena.allocateLabel<FileTag>();
    trap.assignKey(fileLabel, name.str().str());
    trap.emit(FilesTrap{fileLabel, name.str().str()});
  }

  // TODO: Pick a better name to avoid collisions
  std::string trapName = filename.str() + ".trap";
  llvm::SmallString<PATH_MAX> trapPath(config.trapDir);
  llvm::sys::path::append(trapPath, trapName);

  // TODO: The last process wins. Should we do better than that?
  if (std::error_code ec = llvm::sys::fs::rename(tempTrapPath, trapPath)) {
    std::cerr << "Cannot rename temp trap file '" << tempTrapPath.str().str() << "' -> '"
              << trapPath.str().str() << "': " << ec.message() << "\n";
  }
}

void codeql::extractSwiftFiles(const SwiftExtractorConfiguration& config,
                               swift::CompilerInstance& compiler) {
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

  for (auto& [_, module] : compiler.getASTContext().getLoadedModules()) {
    // We only extract system and builtin modules here as the other "user" modules can be built
    // during the build process and then re-used at a later stage. In this case, we extract the
    // user code twice: once during the module build in a form of a source file, and then as
    // a pre-built module during building of the dependent source files.
    if (module->isSystemModule() || module->isBuiltinModule()) {
      llvm::SmallVector<swift::Decl*> decls;
      module->getTopLevelDecls(decls);
      // TODO: pass ModuleDecl directly when we have module extraction in place?
      extractDeclarations(config, decls, compiler, *module);
    } else {
      for (auto file : module->getFiles()) {
        if (!llvm::isa<swift::SourceFile>(file)) {
          continue;
        }
        auto sourceFile = llvm::cast<swift::SourceFile>(file);
        if (sourceFiles.count(sourceFile->getFilename().str()) == 0) {
          continue;
        }
        archiveFile(config, *sourceFile);
        extractDeclarations(config, sourceFile->getTopLevelDecls(), compiler, *module, sourceFile);
      }
    }
  }
}
