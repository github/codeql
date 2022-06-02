#include "SwiftExtractor.h"

#include <filesystem>
#include <fstream>
#include <iostream>
#include <sstream>
#include <memory>
#include <unistd.h>

#include <swift/AST/SourceFile.h>
#include <llvm/ADT/SmallString.h>
#include <llvm/Support/FileSystem.h>
#include <llvm/Support/Path.h>

#include "swift/extractor/trap/generated/TrapClasses.h"
#include "swift/extractor/trap/TrapOutput.h"
#include "swift/extractor/SwiftVisitor.h"

using namespace codeql;

static void archiveFile(const SwiftExtractorConfiguration& config, swift::SourceFile* file) {
  if (std::error_code ec = llvm::sys::fs::create_directories(config.trapDir)) {
    std::cerr << "Cannot create TRAP directory: " << ec.message() << "\n";
    return;
  }

  if (std::error_code ec = llvm::sys::fs::create_directories(config.sourceArchiveDir)) {
    std::cerr << "Cannot create source archive directory: " << ec.message() << "\n";
    return;
  }

  llvm::SmallString<PATH_MAX> srcFilePath(file->getFilename());
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

static void extractFile(const SwiftExtractorConfiguration& config,
                        swift::CompilerInstance& compiler,
                        swift::SourceFile* file) {
  // The extractor can be called several times from different processes with
  // the same input file(s)
  // We are using PID to avoid concurrent access
  // TODO: find a more robust approach to avoid collisions?
  std::string tempTrapName = file->getFilename().str() + '.' + std::to_string(getpid()) + ".trap";
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

  // In the case of emtpy files, the dispatcher is not called, but we still want to 'record' the
  // fact that the file was extracted
  // TODO: to be moved elsewhere
  llvm::SmallString<PATH_MAX> srcFilePath(file->getFilename());
  llvm::sys::fs::make_absolute(srcFilePath);
  auto fileLabel = arena.allocateLabel<FileTag>();
  trap.assignKey(fileLabel, srcFilePath.str().str());
  trap.emit(FilesTrap{fileLabel, srcFilePath.str().str()});

  SwiftVisitor visitor(compiler.getSourceMgr(), arena, trap);
  for (swift::Decl* decl : file->getTopLevelDecls()) {
    visitor.extract(decl);
  }

  // TODO: Pick a better name to avoid collisions
  std::string trapName = file->getFilename().str() + ".trap";
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
  for (auto s : compiler.getPrimarySourceFiles()) {
    archiveFile(config, s);
    extractFile(config, compiler, s);
  }
}
