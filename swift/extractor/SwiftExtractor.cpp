#include "SwiftExtractor.h"

#include <iostream>
#include <memory>
#include <unordered_set>
#include <queue>

#include <swift/AST/SourceFile.h>
#include <swift/AST/Builtins.h>

#include "swift/extractor/translators/SwiftVisitor.h"
#include "swift/extractor/infra/TargetDomains.h"
#include "swift/extractor/infra/file/Path.h"
#include "swift/extractor/infra/SwiftLocationExtractor.h"
#include "swift/extractor/infra/SwiftBodyEmissionStrategy.h"
#include "swift/extractor/mangler/SwiftMangler.h"

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

static fs::path getFilename(swift::ModuleDecl& module,
                            swift::SourceFile* primaryFile,
                            const swift::Decl* lazyDeclaration) {
  if (primaryFile) {
    return resolvePath(primaryFile->getFilename());
  }
  if (lazyDeclaration) {
    SwiftMangler mangler;
    return mangler.mangledName(*lazyDeclaration);
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

static llvm::SmallVector<const swift::Decl*> getTopLevelDecls(swift::ModuleDecl& module,
                                                              swift::SourceFile* primaryFile,
                                                              const swift::Decl* lazyDeclaration) {
  llvm::SmallVector<const swift::Decl*> ret;
  if (lazyDeclaration) {
    ret.push_back(lazyDeclaration);
    return ret;
  }
  ret.push_back(&module);
  llvm::SmallVector<swift::Decl*> topLevelDecls;
  if (primaryFile) {
    primaryFile->getTopLevelDecls(topLevelDecls);
  } else {
    module.getTopLevelDecls(topLevelDecls);
  }
  ret.insert(ret.end(), topLevelDecls.data(), topLevelDecls.data() + topLevelDecls.size());
  return ret;
}

static TrapType getTrapType(swift::SourceFile* primaryFile, const swift::Decl* lazyDeclaration) {
  if (primaryFile) {
    return TrapType::source;
  }
  if (lazyDeclaration) {
    return TrapType::lazy_declaration;
  }
  return TrapType::module;
}

static std::unordered_set<swift::ModuleDecl*> extractDeclarations(
    SwiftExtractorState& state,
    swift::CompilerInstance& compiler,
    swift::ModuleDecl& module,
    swift::SourceFile* primaryFile,
    const swift::Decl* lazyDeclaration) {
  auto filename = getFilename(module, primaryFile, lazyDeclaration);
  if (primaryFile) {
    state.sourceFiles.push_back(filename);
  }

  // The extractor can be called several times from different processes with
  // the same input file(s). Using `TargetFile` the first process will win, and the following
  // will just skip the work
  const auto trapType = getTrapType(primaryFile, lazyDeclaration);
  auto trap = createTargetTrapDomain(state, filename, trapType);
  if (!trap) {
    // another process arrived first, nothing to do for us
    if (lazyDeclaration) {
      state.emittedDeclarations.insert(lazyDeclaration);
    }
    return {};
  }

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

  SwiftLocationExtractor locationExtractor(*trap);
  locationExtractor.emitFile(primaryFile);
  SwiftBodyEmissionStrategy bodyEmissionStrategy(module, primaryFile, lazyDeclaration);
  SwiftVisitor visitor(compiler.getSourceMgr(), state, *trap, locationExtractor,
                       bodyEmissionStrategy);
  auto topLevelDecls = getTopLevelDecls(module, primaryFile, lazyDeclaration);
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

void codeql::extractSwiftFiles(SwiftExtractorState& state, swift::CompilerInstance& compiler) {
  auto inputFiles = collectInputFilenames(compiler);
  std::vector<swift::ModuleDecl*> todo = collectLoadedModules(compiler);
  state.encounteredModules.insert(todo.begin(), todo.end());

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
      archiveFile(state.configuration, *sourceFile);
      encounteredModules =
          extractDeclarations(state, compiler, *module, sourceFile, /*lazy declaration*/ nullptr);
    }
    if (!isFromSourceFile) {
      encounteredModules = extractDeclarations(state, compiler, *module, /*source file*/ nullptr,
                                               /*lazy declaration*/ nullptr);
    }
    for (auto encountered : encounteredModules) {
      if (state.encounteredModules.count(encountered) == 0) {
        todo.push_back(encountered);
        state.encounteredModules.insert(encountered);
      }
    }
  }
}

static void cleanupPendingDeclarations(SwiftExtractorState& state) {
  std::vector<const swift::Decl*> worklist(std::begin(state.pendingDeclarations),
                                           std::end(state.pendingDeclarations));
  for (auto decl : worklist) {
    if (state.emittedDeclarations.count(decl)) {
      state.pendingDeclarations.erase(decl);
    }
  }
}

static void extractLazy(SwiftExtractorState& state, swift::CompilerInstance& compiler) {
  cleanupPendingDeclarations(state);
  std::vector<const swift::Decl*> worklist(std::begin(state.pendingDeclarations),
                                           std::end(state.pendingDeclarations));
  for (auto pending : worklist) {
    extractDeclarations(state, compiler, *pending->getModuleContext(), /*source file*/ nullptr,
                        pending);
  }
}

void codeql::extractExtractLazyDeclarations(SwiftExtractorState& state,
                                            swift::CompilerInstance& compiler) {
  // Just in case
  const int upperBound = 100;
  int iteration = 0;
  while (!state.pendingDeclarations.empty() && iteration++ < upperBound) {
    extractLazy(state, compiler);
  }
  if (iteration >= upperBound) {
    std::cerr << "Swift extractor reached upper bound while extracting lazy declarations\n";
    abort();
  }
}
