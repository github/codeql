#pragma once

#include <swift/AST/SourceFile.h>
#include <swift/AST/Module.h>

namespace codeql {

class SwiftBodyEmissionStrategy {
 public:
  SwiftBodyEmissionStrategy(swift::ModuleDecl& currentModule,
                            swift::SourceFile* currentPrimarySourceFile)
      : currentModule(currentModule), currentPrimarySourceFile(currentPrimarySourceFile) {}
  bool shouldEmitDeclBody(const swift::Decl& decl);

 private:
  swift::ModuleDecl& currentModule;
  swift::SourceFile* currentPrimarySourceFile;
};

}  // namespace codeql
