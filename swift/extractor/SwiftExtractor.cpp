#include "SwiftExtractor.h"

#include <iostream>
#include <memory>
#include <unordered_set>
#include <queue>

#include <swift/AST/SourceFile.h>
#include <swift/AST/Builtins.h>
#include <swift/Basic/FileTypes.h>
#include <llvm/ADT/SmallString.h>
#include <llvm/Support/FileSystem.h>
#include <llvm/Support/Path.h>

#include "swift/extractor/trap/generated/TrapClasses.h"
#include "swift/extractor/trap/TrapDomain.h"
#include "swift/extractor/visitors/SwiftVisitor.h"
#include "swift/extractor/TargetTrapFile.h"

using namespace codeql;
using namespace std::string_literals;

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
  // PCM clang module
  if (module.isNonSwiftModule()) {
    // Several modules with different names might come from .pcm (clang module) files
    // In this case we want to differentiate them
    // Moreover, pcm files may come from caches located in different directories, but are
    // unambiguously identified by the base file name, so we can discard the absolute directory
    std::string filename = "/pcms/"s + llvm::sys::path::filename(module.getModuleFilename()).str();
    filename += "-";
    filename += module.getName().str();
    return filename;
  }
  if (module.isBuiltinModule()) {
    // The Builtin module has an empty filename, let's fix that
    return "/<Builtin>";
  }
  return module.getModuleFilename().str();
}

/* The builtin module is special, as it does not publish any top-level declaration
 * It creates (and caches) declarations on demand when a lookup is carried out
 * (see BuiltinUnit in swift/AST/FileUnit.h for the cache details, and getBuiltinValueDecl in
 * swift/AST/Builtins.h for the creation details)
 * As we want to create the Builtin trap file once and for all so that it works for other
 * extraction runs, rather than collecting what we need we pre-populate the builtin trap with
 * what we expect. This list might need thus to be expanded.
 * Notice, that while swift/AST/Builtins.def has a list of builtin symbols, it does not contain
 * all information required to instantiate builtin variants.
 * Other possible approaches:
 * * create one trap per builtin declaration when encountered
 * * expand the list to all possible builtins (of which there are a lot)
 */
static void getBuiltinDecls(swift::ModuleDecl& builtinModule,
                            llvm::SmallVector<swift::Decl*>& decls) {
  llvm::SmallVector<swift::ValueDecl*> values;
  for (auto symbol : {
           "zeroInitializer", "BridgeObject",   "Word",           "NativeObject",
           "RawPointer",      "Int1",           "Int8",           "Int16",
           "Int32",           "Int64",          "IntLiteral",     "FPIEEE16",
           "FPIEEE32",        "FPIEEE64",       "FPIEEE80",       "Vec2xInt8",
           "Vec4xInt8",       "Vec8xInt8",      "Vec16xInt8",     "Vec32xInt8",
           "Vec64xInt8",      "Vec2xInt16",     "Vec4xInt16",     "Vec8xInt16",
           "Vec16xInt16",     "Vec32xInt16",    "Vec64xInt16",    "Vec2xInt32",
           "Vec4xInt32",      "Vec8xInt32",     "Vec16xInt32",    "Vec32xInt32",
           "Vec64xInt32",     "Vec2xInt64",     "Vec4xInt64",     "Vec8xInt64",
           "Vec16xInt64",     "Vec32xInt64",    "Vec64xInt64",    "Vec2xFPIEEE16",
           "Vec4xFPIEEE16",   "Vec8xFPIEEE16",  "Vec16xFPIEEE16", "Vec32xFPIEEE16",
           "Vec64xFPIEEE16",  "Vec2xFPIEEE32",  "Vec4xFPIEEE32",  "Vec8xFPIEEE32",
           "Vec16xFPIEEE32",  "Vec32xFPIEEE32", "Vec64xFPIEEE32", "Vec2xFPIEEE64",
           "Vec4xFPIEEE64",   "Vec8xFPIEEE64",  "Vec16xFPIEEE64", "Vec32xFPIEEE64",
           "Vec64xFPIEEE64",
       }) {
    builtinModule.lookupValue(builtinModule.getASTContext().getIdentifier(symbol),
                              swift::NLKind::QualifiedLookup, values);
  }
  decls.insert(decls.end(), values.begin(), values.end());
}

static llvm::SmallVector<swift::Decl*> getTopLevelDecls(swift::ModuleDecl& module,
                                                        swift::SourceFile* primaryFile = nullptr) {
  llvm::SmallVector<swift::Decl*> ret;
  ret.push_back(&module);
  if (primaryFile) {
    primaryFile->getTopLevelDecls(ret);
  } else if (module.isBuiltinModule()) {
    getBuiltinDecls(module, ret);
  } else {
    module.getTopLevelDecls(ret);
  }
  return ret;
}

static std::unordered_set<swift::ModuleDecl*> extractDeclarations(
    const SwiftExtractorConfiguration& config,
    swift::CompilerInstance& compiler,
    swift::ModuleDecl& module,
    swift::SourceFile* primaryFile = nullptr) {
  auto filename = getFilename(module, primaryFile);

  // The extractor can be called several times from different processes with
  // the same input file(s). Using `TargetFile` the first process will win, and the following
  // will just skip the work
  auto trapTarget = createTargetTrapFile(config, filename);
  if (!trapTarget) {
    // another process arrived first, nothing to do for us
    return {};
  }
  TrapDomain trap{*trapTarget};

  std::vector<swift::Token> comments;
  if (primaryFile && primaryFile->getBufferID().hasValue()) {
    auto& sourceManager = compiler.getSourceMgr();
    auto tokens = swift::tokenize(compiler.getInvocation().getLangOptions(), sourceManager,
                                  primaryFile->getBufferID().getValue());
    for (auto& token : tokens) {
      if (token.getKind() == swift::tok::comment) {
        comments.push_back(token);
      }
    }
  }

  SwiftVisitor visitor(compiler.getSourceMgr(), trap, module, primaryFile);
  auto topLevelDecls = getTopLevelDecls(module, primaryFile);
  for (auto decl : topLevelDecls) {
    visitor.extract(decl);
  }
  for (auto& comment : comments) {
    visitor.extract(comment);
  }
  return std::move(visitor).getEncounteredModules();
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

void codeql::extractSwiftFiles(const SwiftExtractorConfiguration& config,
                               swift::CompilerInstance& compiler) {
  auto inputFiles = collectInputFilenames(compiler);
  std::vector<swift::ModuleDecl*> todo = {compiler.getMainModule()};
  std::unordered_set<swift::ModuleDecl*> seen = {compiler.getMainModule()};

  while (!todo.empty()) {
    auto module = todo.back();
    todo.pop_back();
    llvm::errs() << "processing module " << module->getName() << '\n';
    bool isFromSourceFile = false;
    std::unordered_set<swift::ModuleDecl*> encounteredModules;
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
      encounteredModules = extractDeclarations(config, compiler, *module, sourceFile);
    }
    if (!isFromSourceFile) {
      encounteredModules = extractDeclarations(config, compiler, *module);
    }
    for (auto encountered : encounteredModules) {
      if (seen.count(encountered) == 0) {
        todo.push_back(encountered);
        seen.insert(encountered);
      }
    }
  }
}
