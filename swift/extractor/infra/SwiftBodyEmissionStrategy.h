#pragma once

#include <swift/AST/SourceFile.h>
#include <swift/AST/Module.h>

namespace codeql {

class SwiftBodyEmissionStrategy {
 public:
  SwiftBodyEmissionStrategy(swift::ModuleDecl& currentModule,
                            swift::SourceFile* currentPrimarySourceFile,
                            const swift::Decl* currentLazyDeclaration)
      : currentModule(currentModule),
        currentPrimarySourceFile(currentPrimarySourceFile),
        currentLazyDeclaration(currentLazyDeclaration) {
    llvm::SmallVector<swift::Decl*> decls;
    currentModule.getTopLevelDecls(decls);
    currentTopLevelDecls.insert(decls.begin(), decls.end());
  }

  bool shouldEmitDeclBody(const swift::Decl& decl);

 private:
  swift::ModuleDecl& currentModule;
  swift::SourceFile* currentPrimarySourceFile;
  const swift::Decl* currentLazyDeclaration;
  std::unordered_set<const swift::Decl*> currentTopLevelDecls;
};

}  // namespace codeql
