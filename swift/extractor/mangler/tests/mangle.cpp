#include "swift/extractor/mangler/SwiftMangler.h"
#include "swift/logging/SwiftLogging.h"

#include <swift/AST/ASTWalker.h>
#include <swift/AST/ClangModuleLoader.h>
#include <swift/AST/Decl.h>
#include <swift/AST/Expr.h>
#include <swift/AST/SourceFile.h>
#include <swift/Basic/InitializeSwiftModules.h>
#include <swift/Basic/LLVMInitialize.h>
#include <swift/Basic/Statistic.h>
#include <swift/Frontend/Frontend.h>
#include <swift/FrontendTool/FrontendTool.h>

#include <iostream>
#include <unordered_set>
#include <vector>

const std::string_view codeql::programName = "mangle-test";
const std::string_view codeql::extractorName = "swift";

class References : public swift::ASTWalker {
 public:
  std::vector<swift::ValueDecl*> declarations;

  PreWalkResult<swift::Expr*> walkToExprPre(swift::Expr* expression) override {
    swift::ValueDecl* declaration = nullptr;
    if (auto reference = llvm::dyn_cast<swift::DeclRefExpr>(expression)) {
      declaration = reference->getDecl();
    } else if (auto reference = llvm::dyn_cast<swift::MemberRefExpr>(expression)) {
      declaration = reference->getMember().getDecl();
    }
    if (declaration && declaration->getDeclContext()->getAsDecl() &&
        llvm::isa<swift::ExtensionDecl>(declaration->getDeclContext()->getAsDecl()) &&
        seen.insert(declaration).second) {
      declarations.push_back(declaration);
    }
    return Action::Continue(expression);
  }

 private:
  std::unordered_set<const swift::Decl*> seen;
};

class Observer : public swift::FrontendObserver {
 public:
  explicit Observer(llvm::StringRef lateMember) : lateMember(lateMember) {}

  void parsedArgs(swift::CompilerInvocation& invocation) override {
    invocation.getFrontendOptions().KeepASTContext = true;
  }

  void performedCompilation(swift::CompilerInstance& compiler) override {
    References references;
    std::vector<swift::ValueDecl*> privateDeclarations;
    for (auto file : compiler.getMainModule()->getFiles()) {
      if (auto source = llvm::dyn_cast<swift::SourceFile>(file)) {
        source->walk(references);
        llvm::SmallVector<swift::Decl*> declarations;
        source->getTopLevelDecls(declarations);
        for (auto declaration : declarations) {
          if (auto value = llvm::dyn_cast<swift::ValueDecl>(declaration);
              value && value->getFormalAccess() == swift::AccessLevel::FilePrivate) {
            privateDeclarations.push_back(value);
          }
        }
      }
    }
    auto& counters = compiler.getStatsReporter()->getFrontendCounters();
    auto before = counters.NumASTBytesAllocated;
    codeql::SwiftRecursiveMangler mangler;
    std::vector<std::string> names;
    for (auto declaration : references.declarations) {
      names.push_back(emit(mangler, declaration));
    }
    for (auto declaration : privateDeclarations) {
      std::cout << "fileprivate\t" << mangler.mangleDecl(*declaration).str() << '\n';
    }
    auto added = counters.NumASTBytesAllocated - before;
    if (!lateMember.empty() && !references.declarations.empty()) {
      auto& context = compiler.getASTContext();
      auto path = swift::ImportPath::Module::Builder(context, "Fixture.Late", '.');
      if (!context.getModule(path.get())) {
        std::cerr << "Late module import failed\n";
        std::exit(1);
      }
      auto extension = llvm::cast<swift::ExtensionDecl>(
          references.declarations.front()->getDeclContext()->getAsDecl());
      for (auto sibling : extension->getExtendedNominal()->getExtensions()) {
        for (auto member : sibling->getAllMembers()) {
          if (auto value = llvm::dyn_cast<swift::ValueDecl>(member);
              value && value->getName().getBaseName().userFacingName() == lateMember) {
            emit(mangler, value);
          }
        }
      }
      for (size_t i = 0; i < references.declarations.size(); ++i) {
        std::cout << "late-import-stable\t"
                  << (mangler.mangleDecl(*references.declarations[i]).str() == names[i]) << '\n';
      }
    }
    std::cout << "additional-ast-bytes\t" << added << '\n';
    std::cout << "references\t" << references.declarations.size() << '\n';
  }

 private:
  llvm::StringRef lateMember;

  static std::string emit(codeql::SwiftRecursiveMangler& mangler, swift::ValueDecl* declaration) {
    auto name = mangler.mangleDecl(*declaration).str();
    auto repeated = mangler.mangleDecl(*declaration).str();
    auto extension = llvm::cast<swift::ExtensionDecl>(declaration->getDeclContext()->getAsDecl());
    std::cout << declaration->getName().getBaseName().userFacingName().str() << '\t' << name << '\t'
              << mangler.mangleDecl(*extension).str() << '\t' << (name == repeated) << '\n';
    return name;
  }
};

int main(int argc, char** argv) {
  PROGRAM_START(argc, argv);
  INITIALIZE_LLVM();
  initializeSwiftModules();
  llvm::StringRef lateMember;
  if (argc > 1 && std::string_view(argv[1]) == "--late-import") {
    lateMember = "late";
  } else if (argc > 1 && std::string_view(argv[1]) == "--late-global-import") {
    lateMember = "lateValue";
  }
  Observer observer(lateMember);
  auto offset = lateMember.empty() ? 1 : 2;
  return swift::performFrontend({argv + offset, static_cast<size_t>(argc - offset)}, "mangle-test",
                                reinterpret_cast<void*>(main), &observer);
}
