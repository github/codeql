#include "SwiftExtractor.h"

#include <iostream>
#include <memory>
#include <unordered_set>
#include <queue>

#include <swift/AST/SourceFile.h>
#include <swift/AST/Builtins.h>

#include "swift/extractor/trap/TrapDomain.h"
#include "swift/extractor/translators/SwiftVisitor.h"
#include "swift/extractor/TargetTrapFile.h"
#include "swift/extractor/SwiftBuiltinSymbols.h"
#include "swift/extractor/infra/file/Path.h"

using namespace codeql;
using namespace std::string_literals;
namespace fs = std::filesystem;

static void ensureDirectory(const char* label, const fs::path& dir) {
  std::error_code ec;
  fs::create_directories(dir, ec);
  if (ec) {
    std::cerr << "Cannot create " << label << " directory: " << ec.message() << "\n";
    std::abort();
  }
}

static void archiveFile(const SwiftExtractorConfiguration& config, swift::SourceFile& file) {
  auto source = codeql::resolvePath(file.getFilename());
  auto destination = config.sourceArchiveDir / source.relative_path();

  ensureDirectory("source archive destination", destination.parent_path());

  std::error_code ec;
  fs::copy(source, destination, fs::copy_options::overwrite_existing, ec);

  if (ec) {
    std::cerr << "Cannot archive source file " << source << " -> " << destination << ": "
              << ec.message() << "\n";
  }
}

static fs::path getFilename(swift::ModuleDecl& module, swift::SourceFile* primaryFile) {
  if (primaryFile) {
    return resolvePath(primaryFile->getFilename());
  }
  // PCM clang module
  if (module.isNonSwiftModule()) {
    // Several modules with different names might come from .pcm (clang module) files
    // In this case we want to differentiate them
    // Moreover, pcm files may come from caches located in different directories, but are
    // unambiguously identified by the base file name, so we can discard the absolute directory
    fs::path filename = "/pcms";
    filename /= fs::path{std::string_view{module.getModuleFilename()}}.filename();
    filename += "-";
    filename += module.getName().str();
    return filename;
  }
  if (module.isBuiltinModule()) {
    // The Builtin module has an empty filename, let's fix that
    return "/__Builtin__";
  }
  std::string_view filename = module.getModuleFilename();
  // there is a special case of a module without an actual filename reporting `<imports>`: in this
  // case we want to avoid the `<>` characters, in case a dirty DB is imported on Windows
  if (filename == "<imports>") {
    return "/__imports__";
  }
  return resolvePath(filename);
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
  for (auto symbol : swiftBuiltins) {
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

static std::vector<swift::ModuleDecl*> collectLoadedModules(swift::CompilerInstance& compiler) {
  std::vector<swift::ModuleDecl*> ret;
  for (const auto& [id, module] : compiler.getASTContext().getLoadedModules()) {
    std::ignore = id;
    ret.push_back(module);
  }
  return ret;
}

void codeql::extractSwiftFiles(const SwiftExtractorConfiguration& config,
                               swift::CompilerInstance& compiler) {
  auto inputFiles = collectInputFilenames(compiler);
  std::vector<swift::ModuleDecl*> todo = collectLoadedModules(compiler);
  std::unordered_set<swift::ModuleDecl*> seen{todo.begin(), todo.end()};

  while (!todo.empty()) {
    auto module = todo.back();
    todo.pop_back();
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
