#include "Extractor.h"

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

using namespace codeql;

Extractor::Extractor(const Configuration& config, swift::CompilerInstance& instance)
    : config{config}, compiler{instance} {}

void Extractor::extract() {
  // Swift frontend can be called in several different modes, we are interested
  // only in the cases when either a primary or a main source file is present
  if (compiler.getPrimarySourceFiles().empty()) {
    swift::ModuleDecl* module = compiler.getMainModule();
    if (!module->getFiles().empty() &&
        module->getFiles().front()->getKind() == swift::FileUnitKind::Source) {
      // We can only call getMainSourceFile if the first file is of a Source kind
      swift::SourceFile& file = module->getMainSourceFile();
      extractFile(file);
    }
  } else {
    for (auto s : compiler.getPrimarySourceFiles()) {
      extractFile(*s);
    }
  }
}

void Extractor::extractFile(swift::SourceFile& file) {
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

  // The extractor can be called several times from different processes with
  // the same input file(s)
  // We are using PID to avoid concurrent access
  // TODO: find a more robust approach to avoid collisions?
  std::string tempTrapName = file.getFilename().str() + '.' + std::to_string(getpid()) + ".trap";
  llvm::SmallString<PATH_MAX> tempTrapPath(config.trapDir);
  llvm::sys::path::append(tempTrapPath, tempTrapName);

  std::ofstream trap(tempTrapPath.str().str());
  if (!trap) {
    std::error_code ec;
    ec.assign(errno, std::generic_category());
    std::cerr << "Cannot create temp trap file '" << tempTrapPath.str().str()
              << "': " << ec.message() << "\n";
    return;
  }
  std::stringstream ss;
  ss << "-frontend ";
  for (auto opt : config.frontendOptions) {
    ss << std::quoted(opt) << " ";
  }
  ss << "\n";
  trap << "// frontend-options: " << ss.str();

  trap << "#0=*\n";
  trap << "files(#0, " << std::quoted(srcFilePath.str().str()) << ")\n";

  // TODO: Pick a better name to avoid collisions
  std::string trapName = file.getFilename().str() + ".trap";
  llvm::SmallString<PATH_MAX> trapPath(config.trapDir);
  llvm::sys::path::append(trapPath, trapName);

  // TODO: The last process wins. Should we do better than that?
  if (std::error_code ec = llvm::sys::fs::rename(tempTrapPath, trapPath)) {
    std::cerr << "Cannot rename temp trap file '" << tempTrapPath.str().str() << "' -> '"
              << trapPath.str().str() << "': " << ec.message() << "\n";
  }
}

