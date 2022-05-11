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

#include "swift/extractor/trap/TrapClasses.h"
#include "swift/extractor/trap/TrapArena.h"
#include "swift/extractor/trap/TrapOutput.h"

using namespace codeql;

static void extractFile(const SwiftExtractorConfiguration& config, swift::SourceFile& file) {
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

  if (TrapOutput trap{config, file.getFilename().str()}) {
    TrapArena arena{};

    auto label = arena.allocateLabel<File::Tag>();
    trap.assignStar(label);

    File f{};
    f.id = label;
    f.name = srcFilePath.str().str();
    trap.emit(f);
  }
}

void codeql::extractSwiftFiles(const SwiftExtractorConfiguration& config,
                               swift::CompilerInstance& compiler) {
  // Swift frontend can be called in several different modes, we are interested
  // only in the cases when either a primary or a main source file is present
  if (compiler.getPrimarySourceFiles().empty()) {
    swift::ModuleDecl* module = compiler.getMainModule();
    if (!module->getFiles().empty() &&
        module->getFiles().front()->getKind() == swift::FileUnitKind::Source) {
      // We can only call getMainSourceFile if the first file is of a Source kind
      swift::SourceFile& file = module->getMainSourceFile();
      extractFile(config, file);
    }
  } else {
    for (auto s : compiler.getPrimarySourceFiles()) {
      extractFile(config, *s);
    }
  }
}
